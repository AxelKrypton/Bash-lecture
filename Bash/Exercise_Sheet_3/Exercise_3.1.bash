function SplitCombinedOptionsIntoMultipleOptions()
{
    local newOptions value splittedOptions
    newOptions=()
    for value in "$@"; do
        if [[ $value =~ ^-[[:alpha:]]+$ ]]; then
            splittedOptions=( $(grep -o "." <<< "${value:1}") )
            for option in "${splittedOptions[@]}"; do
                newOptions+=( "-$option" )
            done
        else
            newOptions+=( "$value" )
        fi
    done
    # This function is meant to be called from within readarray
    # NOTE: Use '\n' as delimiter -> fine since no '\n' neither
    #       in options, nor in values!
    printf "%s\n" "${newOptions[@]}"
}

function CheckMutuallyExclusiveOptions()
{
    if [[ ${#mutuallyExclusiveSpecifiedOptions[@]} -gt 1 ]]; then
        echo -e '\e[91mThe options'
        printf '  \e[1m%s\e[22m\n' "${mutuallyExclusiveOptions[@]}"
        echo -e 'are mutually exclusive and cannot be combined!\e[0m'
        exit 1
    fi
}

function PrintHelperAndExitIfNeeded()
{
    for option in "$@"; do
        if [[ ${option} =~ ^-(h|-help)$ ]]; then
            printf '\n\n\e[92m Available options to the present script:\n\n'
            printf '    \e[96m%-20s\e[0m  ->  \e[95m%s\e[0m\n'\
                   '-f | --file' 'Existing input file name'\
                   '-b | --beta' 'A positive number with at maximum 4 decimal digits'\
                   '-v | --verbose' 'Enable verbose mode'\
                   '-s | --sizes' 'Positive integer(s)'\
                   '-a | --aspectRatios' 'Positive integer(s)'\
                   '-r | --range' 'Lower and upper bounds'\
                   '-w | --walltime' 'Walltime either as "d-hh:mm:ss" or with shorter notation'\
                   '--' 'Separate options from list of files'
            printf '\n\e[1;4;91mATTENTION\e[24m:\e[22m Options "-s" and "-a" are mutually exclusive!\n\n\n\e[0m'
            exit 0
        fi
    done
}

function ParseCommandLineOptions()
{
    if [[ $# -eq 0 ]]; then
        return
    fi

    local mutuallyExclusiveSpecifiedOptions mutuallyExclusiveOptions commandLineOptions
    mutuallyExclusiveSpecifiedOptions=()
    mutuallyExclusiveOptions=( "-s | --sizes" "-a | --aspectRatios")

    readarray -t commandLineOptions <<< "$(SplitCombinedOptionsIntoMultipleOptions "$@")"
    set -- "${commandLineOptions[@]}"
    PrintHelperAndExitIfNeeded "$@"
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h | --help )
                shift ;;
            -f | --file )
                if [[ $2 =~ ^(-|$) ]]; then
                    printf "\n  \e[91mThe value of the option \e[1m${1}\e[22m was not correctly specified (either forgotten or invalid)!\e[0m\n\n"
                    exit 1
                elif [[ ! -f $2 ]]; then
                    echo "The value of the option \"${1}\" does not refer to an existing, regular file!"
                    exit 1
                else
                    filename="$2"
                fi
                shift 2
                ;;
            -b | --beta )
                if [[ ! $2 =~ ^[0-9]*[.][0-9]{4}$ ]]; then
                    printf "\n  \e[91mThe value of the option \e[1m${1}\e[22m was not correctly specified (either forgotten or invalid)!\e[0m\n\n"
                    exit 1
                else
                    beta="$2"
                fi
                shift 2
                ;;
            -v | --verbose )
                verbose='TRUE'
                shift
                ;;
            -s | --sizes )
                mutuallyExclusiveSpecifiedOptions+=( "$1" )
                while [[ $2 =~ ^[1-9][0-9]*$ ]]; do
                    sizes+=( $2 )
                    shift
                done
                shift
                ;;
            -a | --aspectRatios )
                mutuallyExclusiveSpecifiedOptions+=( "$1" )
                while [[ $2 =~ ^[1-9][0-9]*$ ]]; do
                    aspectRatios+=( $2 )
                    shift
                done
                shift          
                ;;
            -r | --range )
                formatRegex='^[-]?(0|[1-9][0-9]*)?([.][0-9]*)?$'
                if [[ $2 =~ ${formatRegex} ]] && [[ $3 =~ ${formatRegex} ]]; then
                    rangeMin="$2"
                    rangeMax="$3"
                    if [[ $(bc -l <<< "${rangeMin}<${rangeMax}") -eq 0 ]]; then
                        rangeMin="$3"
                        rangeMax="$2"                    
                    fi
                else
                    printf "\n  \e[91mThe value of the option \e[1m${1}\e[22m was not correctly specified (either forgotten or invalid)!\e[0m\n\n"
                    exit 1                
                fi
                shift 3
                ;;
            -w | --walltime )
                formatRegexA='^[0-9]-[0-9]{2}(:[0-9]{2}){2}$'
                formatRegexB='^([0-9]+[dhms])+$'
                if [[ $2 =~ ${formatRegexA} ]] || [[ $2 =~ ${formatRegexB} ]]; then
                    walltime=$2
                else
                    printf "\n  \e[91mThe value of the option \e[1m${1}\e[22m was not correctly specified (either forgotten or invalid)!\e[0m\n\n"
                    exit 1                
                fi
                shift 2
                ;;
            -- )
                files=( "${@:2}" )
                break
                ;;
            * )
                echo -e "\e[91mUnrecognised option \"\e[1m${1}\"\e[22m.\e[0m\n\n"
                exit 1
                ;;
        esac
    done
}
