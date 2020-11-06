# You do not need a shebang here! This script will be sourced.

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    printf "\n ERROR: File \"${BASH_SOURCE[0]}\" cannot be executed!\n\n"
    exit 1
fi

# Here we define a 'measure' function just to test the autocompletion,
# but in general 'measure' is your own executable script!
function measure()
{
    printf 'I was called with %d arguments:\n' $#
    printf '%s\n' "$@"
}


function _measure_completion()
{
    local optionsToBeProposed word i index
    optionsToBeProposed=( '--inputfile' '--verbose' '--conservative' )
    # The COMP_WORDS contains the individual words in the current command line
    #  -> use it to avoid proposing command line options already given!
    #
    # NOTE: It is important to iterate over the COMP_WORDS but to skip
    #       the first entry that is the command 'measure' and the
    #       last one which is the one being matched
    for((i=1; i<${#COMP_WORDS[@]}-1; i++)); do
        word=${COMP_WORDS[i]}
        if [[ ! ${word} =~ ^-- ]]; then
            continue
        fi
        for index in "${!optionsToBeProposed[@]}"; do
            if [[ "${optionsToBeProposed[index]}" == "${word}" ]]; then
                unset -v 'optionsToBeProposed[${index}]'
                #Make array not sparse for following word
                optionsToBeProposed=("${optionsToBeProposed[@]}")
                break
            fi
        done
        if [[ "${word}" == "$3" ]]; then
            break
        fi
    done
    case "$3" in
        --inputfile )
            COMPREPLY=( $(compgen -f -- "$2") )
            ;;
        * )
            COMPREPLY=(
                $(compgen -W "${optionsToBeProposed[*]}" -- "$2")
            )
            ;;
    esac
}

complete -o filenames -F _measure_completion measure
