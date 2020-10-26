#!/usr/bin/env bash

shopt -s extglob nullglob

# Use logger
source ../Exercise_Sheet_3/Exercise_4.bash || exit 2

function ParseCommandLineParameters()
{
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h | --help )
                printf '\e[92m Available options to the present script:\n\n'
                printf '    \e[96m%-20s\e[0m  ->  \e[95m%s\e[0m\n'\
                       '-f | --file' 'Existing input file name'
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
            * )
                PrintFatal "Unrecognised option \[1m${1}\e[22m."
                ;;
        esac
    done
}

function SplitInputInSeveralFiles()
{
    awk 'NR==1{
             numCols=NF
         }
         {
             if(NF!=numCols) {
                 print "Line" NR "has not " numCols "fields" > "/dev/stderr"
                 exit 1
             }
             for(i=1; i<=numCols; i++){
                 print $i >> "column_" i ".dat"
             }
         }' "${inputFile}"
}

function RemoveAllAuxFiles()
{
    rm column_+([0-9])_{0..9}.aux column_+([0-9]).dat || PrintError "Unable to remove some auxiliary files!"
    printf '\r' # Aesthetics: remove e.g. ^C from signal
    PrintInfo 'Auxiliary files cleaned up! :)'
}



#-----------------------------------------------
# NOTE: Many stuff here hard-coded -> not the best code!
echo
inputFile=''
ParseCommandLineParameters "$@"

if [[ ${inputFile} = '' ]]; then
    PrintFatal "Input file not specified!"
fi

trap 'RemoveAllAuxFiles' EXIT

SplitInputInSeveralFiles || PrintFatal "Splitting input file failed!"
PrintInfo "Splitting of file in columns done"
for file in column_+([0-9]).dat; do
    PrintDebug "Working on file '${file}'"
    sort -g "${file}" > "${file/%column/output}"
    touch "${file%%.dat}_"{0..9}.aux
    sleep 1
    rm "${file%%.dat}_"{0..9}.aux "${file}" || PrintError "Unable to remove some auxiliary files!"
done

