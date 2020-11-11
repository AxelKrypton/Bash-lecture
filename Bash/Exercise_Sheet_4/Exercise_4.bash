#!/usr/bin/env bash

# Use Logger
source ../Exercise_Sheet_3/Exercise_4.bash || exit 2

function ParseCommandLineParameters()
{
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h | --help )
                printf '\e[92m Available options to the present script:\n\n'
                printf '    \e[96m%-20s\e[0m  ->  \e[95m%s\e[0m\n'\
                       '-f | --file' 'Existing input file name'\
                       '-t | --task' 'Exercise task number, 1 to 6'
                printf '\n'
                exit 0
                ;;
            -f | --file )
                if [[ $2 =~ ^(-|$) ]]; then
                    PrintFatal "The value of the option \e[1m${1}\e[22m was not correctly specified (either forgotten or invalid)!"
                elif [[ ! -f $2 ]]; then
                    PrintFatal "The value of the option \"${1}\" does not refer to an existing, regular file!"
                else
                    inputFile="$2"
                fi
                shift 2
                ;;
            -t | --task )
                if [[ ! $2 =~ ^[1-6]$ ]]; then
                    PrintFatal "The value of the option \e[1m${1}\e[22m was not correctly specified (either forgotten or invalid)!"
                else
                    task="$2"
                fi
                shift 2
                ;;
            * )
                PrintFatal "Unrecognised option \e[1m${1}\e[22m."
                ;;
        esac
    done
}


#-----------------------------------------------
# NOTE: Many stuff here hard-coded -> not the best code!
echo
task=''
inputFile=''
ParseCommandLineParameters "$@"

if [[ ${inputFile} = '' ]]; then
    PrintFatal "Input file not specified!"
fi

case "${task}" in
    1 )
        PrintInfo "Print the first 5 and last 10 lines:"\
                  "  sed -n '1,5p ; '\"\$(( \$(wc -l < ${inputFile}) - 10))\"',\$p' \"${inputFile}\""
        sed -n '1,5p ; '"$(( $(wc -l < ${inputFile}) - 10))"',$p' "${inputFile}"
        ;;
    2 )
        PrintInfo "Print every third line:"\
                  "  sed -n '1~3p'  \"${inputFile}\""
        sed -n '1~3p' "${inputFile}"
        ;;
    3 )
        PrintInfo "Print lines starting by a vowel:"\
                  "  sed -n '/^[aeiouAEIOU]/p'  \"${inputFile}\""
        sed -n '/^[aeiouAEIOU]/p' "${inputFile}"
        ;;
    4 )
        PrintInfo "Print lines for which the integer number is larger than 999:"\
                  "  sed -nr '/[0-9]{4}[[:space:]]*\$/p'  \"${inputFile}\""
        sed -nr '/[0-9]{4}[[:space:]]*$/p' "${inputFile}"
        ;;
    5 )
        PrintInfo "Print the number of lines in the file:"\
                  "  sed -n '\$='  \"${inputFile}\""
        sed -n '$=' "${inputFile}"
        ;;
    6 )
        PrintInfo "Print lines for which the number in the second column is multiple of 5:"\
                  "  sed -n '/[05][[:space:]]*$/p'  \"${inputFile}\""
        sed -n '/[05][[:space:]]*$/p' "${inputFile}"
        ;;
    * )
        PrintWarning "Task not specified!"
        ;;
esac
echo
