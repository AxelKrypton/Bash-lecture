#!/usr/bin/env bash

if [[ ! "$1 $2" =~ ^-t\ [123]$ ]]; then
    printf '\n  Give "-t N" (N=1, N=2 or N=3) as option to select the exercise task.\n\n' >&2
    exit 1
else
    set -- "$1 $2"
fi

# TASK 1: Remove echo to really rename

if [[ $1 = '-t 1' ]]; then

    extension_1='jpeg'
    extension_2='jpg'

    for file in *.${extension_1}; do
        if [[ -f ${file} ]]; then # To avoid loop iteration if glob is not matched
            if [[ ! -e "${file/%.${extension_1}/.${extension_2}}" ]]; then
                echo mv "${file}" "${file/%.${extension_1}/.${extension_2}}"
            fi
        fi
    done

    exit 0
fi

# TASK 2: Remove echo to really rename

if [[ $1 = '-t 2' ]]; then

    for fileOrFolder in *\ *; do
        if [[ -e ${fileOrFolder} ]]; then # To avoid loop iteration if glob is not matched
            if [[ ! -e "${fileOrFolder// /_}" ]]; then
                echo mv "${fileOrFolder}" "${fileOrFolder// /_}"
            fi
        fi
    done

    exit 0
fi

# TASK 3

shopt -s extglob nullglob
# extglob is a flag used by the parser.
# Functions and in general compound commands are parsed in entirety AHEAD OF EXECUTION!
# Thus, extglob must be set before that content is parsed; setting it at execution time
# but after parse time does not have any effect for previously-parsed content.
#  [from https://stackoverflow.com/a/49283991]
#
# This to say that putting the shopt line in the if would a mistake!

if [[ $1 = '-t 3' ]]; then

    for file in conf.+([0-9]); do
        if [[ ! -f "${file/conf/prng}" ]]; then
            rm "${file}"
        fi
    done
    for file in prng.+([0-9]); do
        if [[ ! -f "${file/prng/conf}" ]]; then
            rm "${file}"
        fi
    done

    lastConf=$(printf '%s\n' conf.+([0-9]) | sort -V | tail -n 1)
    lastPrng=$(printf '%s\n' prng.+([0-9]) | sort -V | tail -n 1)

    if [[ ${lastConf} = '' ]] || [[ ${lastPrng} = '' ]]; then 
        printf '\n  No complete checkpoint found!\n\n'
    else
        numberWithoutLeadingZeroes="${lastConf#*.*(0)}"       
        printf "\n  The last checkpoint was the number ${numberWithoutLeadingZeroes} (${lastConf} and ${lastPrng}).\n\n"
    fi

    exit 0
fi
