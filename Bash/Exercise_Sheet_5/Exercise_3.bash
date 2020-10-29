#!/usr/bin/env bash

# Use stricter bash mode
set -o nounset -o errexit -o pipefail
shopt -s inherit_errexit

# Use Logger
source ../Exercise_Sheet_3/Exercise_4.bash || exit 2

function ParseCommandLineArguments()
{
    for option in "$@"; do
        if [[ ${option} =~ ^-(h|-help)$ ]]; then
            set -- '--help'
        fi
    done

    # The actual parsing
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help )
                printf '\n\n\e[92m Available options to the present script:\n\n'
                printf '    \e[96m%-20s\e[0m  ->  \e[95m%s\e[0m\n'\
                       '-f | --dataFile' 'Existing input file name (default: "data.dat")'\
                       '-t | --texFile'  'Existing tex file name (default: "plot.tex")'\
                       '-x | --xColumn'  'Index of the column to be used as x-values'\
                       '-y | --yColumn'  'Index of the column to be used as y-values'\
                printf '\n \e[1;4;91mATTENTION\e[24m:\e[22m Columns indexes ranges from 0.\n\n\n\e[0m'
                exit 0 ;;
            -f | --dataFile )
                if [[ $2 =~ ^(-|$) ]]; then
                    printf "\n  \e[91mThe value of the option \e[1m${1}\e[22m was not correctly specified (either forgotten or invalid)!\e[0m\n\n" >&2
                    exit 1
                else
                    dataFilename="$2"
                fi
                shift 2
                ;;
            -x | --xColumn )
                if [[ ! $2 =~ ^(0|[1-9][0-9]*)$ ]]; then
                    printf "\n  \e[91mThe value of the option \e[1m${1}\e[22m was not correctly specified (either forgotten or invalid)!\e[0m\n\n" >&2
                    exit 1
                else
                    xColumn="$2"
                fi
                shift 2
                ;;
            -y | --yColumn )
                if [[ ! $2 =~ ^(0|[1-9][0-9]*)$ ]]; then
                    printf "\n  \e[91mThe value of the option \e[1m${1}\e[22m was not correctly specified (either forgotten or invalid)!\e[0m\n\n" >&2
                    exit 1
                else
                    yColumn="$2"
                fi
                shift 2
                ;;
            -t | --texFile )
                if [[ $2 =~ ^(-|$) ]]; then
                    printf "\n  \e[91mThe value of the option \e[1m${1}\e[22m was not correctly specified (either forgotten or invalid)!\e[0m\n\n" >&2
                    exit 1
                else
                    texFilename="$2"
                fi
                shift 2
                ;;
            * )
                echo -e "\e[91mUnrecognised option \[1m${1}\e[22m." >&2
                exit 1
                ;;
        esac
    done
}

function ClearAuxiliaryFiles()
{
    local auxFile
    for auxFile in "${texFilename/%.tex/}."{log,aux}; do
        PrintInfo "Removing \"${auxFile}\""
        rm -f "${auxFile}"
    done
}

#=======================================================================
# Global variables
dataFilename='data.dat'
texFilename='Plot.tex'
xColumn=0
yColumn=1
if [[ ${VERBOSE-} = '' ]]; then #To be able to use Logger with set -u on!
    VERBOSE='INFO'
fi
echo
ParseCommandLineArguments "$@"

# Validate input
if [[ ! -f "${dataFilename}" ]]; then
    PrintFatal "Data file '${dataFilename}' was not found!"
elif [[ ! -f "${texFilename}" ]]; then
    PrintFatal "TeX file '${texFilename}' was not found!"
else
    columnsInFile=$(awk 'NR==1{print NF; exit}' "${dataFilename}")
    if (( xColumn >= columnsInFile )); then
        PrintFatal "Too large column index specified for x-values: ${xColumn} must be smaller than ${columnsInFile}."
    elif (( yColumn >= columnsInFile )); then
        PrintFatal "Too large column index specified for y-values: ${yColumn} must be smaller than ${columnsInFile}."
    fi
fi

# Mock pdflatex if not available
if ! hash pdflatex &>/dev/null; then
    function pdflatex()
    {
        echo "$@"; sleep 5
        touch 'Plot.'{log,aux,pdf}
    }
fi

# Setting trap here, because the cleaning should not be done if the exit exits
# before than here, e.g. because of error in parsing the options.
trap 'ClearAuxiliaryFiles' EXIT

PrintInfo 'Compiling LaTeX code:'
if pdflatex -halt-on-error -interaction=batchmode "\def\filename{${dataFilename}} \def\xColumn{${xColumn}} \def\yColumn{${yColumn}} \input{${texFilename}}"; then
    echo; PrintInfo 'LaTeX compilation successfully completed!'
else
    echo; PrintFatal 'Error compiling LaTeX code!'
fi
