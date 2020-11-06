#!/usr/bin/env bash

set -o errexit -o nounset
shopt -s nullglob globstar

extensions=( "$@" )
if [[ ${#extensions[@]} -eq 0 ]]; then
    printf '\nGive one or more extensions as command line arguments\n\n'
    exit 1
fi

echo
for ext in "${extensions[@]}"; do
    counter=0
    numberOfLines=0
    largestFile=''
    maximumSize=-1 #No file has negative size and we can then save also the filename in the if
    ext="${ext/#[.]/}"
    for file in **/*".${ext}"; do
        counter=$(( counter+1 ))
        numberOfLines=$(( numberOfLines + $(grep -c '' "${file}") ))
        tmpSize=$(stat --format '%s' "${file}")
        if [[ ${tmpSize} -gt ${maximumSize} ]]; then
            maximumSize=${tmpSize}
            largestFile="${file}"
        fi
    done
    if [[ ${counter} -eq 0 ]]; then
        printf '%60s\n\n' "There is no file with \".${ext}\" extension."
    else
        printf '%60s: %-s\n'\
               "Number of files with \".${ext}\" extension" "${counter}"\
               "The largest file is \"${largestFile}\" and its size is" "$(( maximumSize/1000 ))KB"\
               "The total number of lines of all files is" "${numberOfLines}"
        echo
    fi
done

# NOTE: After having discussed redirection on Day 3 it is possible to
#        - use $(wc -l < "${file}") to get the number of lines
#        - find the maximum size as
#             stat --format '%s' **/*".${ext}" | sort -n | tail -n1
