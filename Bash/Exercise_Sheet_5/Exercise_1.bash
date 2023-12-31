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
        PrintInfo "Print every third line:"\
                  "  awk '(NR-1)%3==0' \"${inputFile}\""
        awk '(NR-1)%3==0' "${inputFile}"
        ;;
    2 )
        PrintInfo "Display only lines for which the number on the second column is smaller than 1000:"\
                  "  awk '\$2<1000' \"${inputFile}\""
        awk '$2<1000' "${inputFile}"
        ;;
    3 )
        PrintInfo "Calculate the average of the second column:"\
                  "  awk '{sum+=\$2}END{printf \"The average of the second column is %.2f\\\\n\", sum/NR}' \"${inputFile}\""
        awk '{sum+=$2}END{printf "The average of the second column is %.2f\n", sum/NR}' "${inputFile}"
        ;;
    4 )
        PrintInfo "Print lines starting by a vowel:"\
                  "  awk '\$1 ~ /^[aeiouAEIOU]/' \"${inputFile}\""
        awk '$1 ~ /^[aeiouAEIOU]/' "${inputFile}"
        ;;
    5 )
        PrintInfo "Print the first column word if the second column contains a number larger than 3000:"\
                  "  awk '\$2>3000{print \$1}' \"${inputFile}\""
        awk '$2>3000{print $1}' "${inputFile}"
        ;;
    * )
        PrintWarning "Task not existing!"
        ;;
esac
echo
