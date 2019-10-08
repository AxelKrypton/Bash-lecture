#!/bin/bash

if [[ ! "$1 $2" =~ ^-t\ [12w]$ ]]; then
    printf '\n  Give "-t N" (N=w, N=1 or N=2) as option to select the exercise task.\n\n' >&2
    exit 1
else
    set -- "$1 $2" "${@:3}"
fi

# WARMUP

if [[ $1 = '-t w' ]]; then

    echo
    stringArray=( $'Hello\nworld' 'Hello' 'Bye' 'Goodbye everyone' 'Wow' )
    numberArray=( 200 101 31 5 7 11 )
    sparseArray=( [10]=$'Hello\nworld' [3]='Bye' [5]='Ciao' )
    printf "%.0s-" {1..50}; echo
    echo "stringArray=( \$'Hello\nworld' 'Hello' 'Bye' 'Goodbye everyone' 'Wow' )"
    echo 'numberArray=( 200 101 31 5 7 11 )'
    echo "sparseArray=( [10]=\$'Hello\nworld' [3]='Bye' [5]='Ciao' )"

    # Longest entry of array
    for entry in "${stringArray[@]}"; do
        if [[ ${#entry} -gt ${#longestEntry} ]]; then
            longestEntry="${entry}"
        fi
    done
    printf "%.0s-" {1..50}; echo
    printf "The longest entry of \"stringArray\" is \"${longestEntry}\"\n"

    # Maximum of numeric array
    for entry in "${numberArray[@]}"; do
        if [[ ${entry} -gt "${maximum}" ]]; then
            maximum="${entry}"
        fi
    done
    printf "%.0s-" {1..50}; echo
    printf "The maximum entry of \"numberArray\" is \"${maximum}\"\n"

    # Common entries in two arrays
    commonEntries=()
    for entry_A in "${stringArray[@]}"; do
        for entry_B in "${sparseArray[@]}"; do
            if [[ "${entry_A}" = "${entry_B}" ]]; then
                commonEntries+=( "${entry_A}" )
                continue 2
            fi
        done
    done
    printf "%.0s-" {1..50}; echo
    for index in "${!commonEntries[@]}"; do
        echo "commonEntries[$index]=${commonEntries[index]}"
    done
    echo    

    # Sort (alphabetically!) an array before bash 4.4 coping with '\n' in entries (indeed before bash v4)
    # NOTE: Using -d $'\0' rather than -d '' makes no difference, but it makes it obvious
    #       what you're expecting the delimiter to be!
    #          https://transnum.blogspot.com/2008/11/bashs-read-built-in-supports-0-as.html
    sorted_A=()
    while read -d $'\0' element; do
        sorted_A[${#sorted_A[@]}]="${element}"
    done < <(printf '%s\0' "${stringArray[@]}" | sort -z)
    echo '---- Bash < v4 ----'
    for index in "${!sorted_A[@]}"; do
        echo "sorted_A[$index]=${sorted_A[index]}"
    done
    echo

    # Sort an array after bash 4.4
    echo '---- Bash >= v4.4 ----'
    readarray -d $'\0' -t sorted_B < <(printf '%s\0' "${stringArray[@]}" | sort -z)
    for index in "${!sorted_B[@]}"; do
        echo "sorted_B[$index]=${sorted_B[index]}"
    done
    echo

    # Check if an array is sparse
    printf "%.0s-" {1..50}; echo
    indecesOfArray=( ${!sparseArray[@]} )
    if [[ ${#sparseArray[@]} -ne $(( indecesOfArray[-1] +1 )) ]]; then
        echo "Array \"sparseArray\" is sparse."
    else
        echo "Array \"sparseArray\" is NOT sparse."
    fi
    indecesOfArray=( ${!stringArray[@]} )
    if [[ ${#stringArray[@]} -ne $(( indecesOfArray[-1] +1 )) ]]; then
        echo "Array \"stringArray\" is sparse."
    else
        echo "Array \"stringArray\" is NOT sparse."
    fi
    echo

fi

# NOTE: many lines might be simplified using arithmetic evaluation (see Day 3)

# TASK 1: Avoid using ls in scripts! http://mywiki.wooledge.org/ParsingLs

if [[ $1 = '-t 1' ]]; then

    declare -A reportOnFiles
    for file in *; do
        extension="${file##*.}"
        reportOnFiles[${extension}]=$(( reportOnFiles[${extension}]+1 ))
    done

    for key in "${!reportOnFiles[@]}"; do
        printf ' Files with extenstion %8s: %d\n'\
               "\"${key}\""\
               ${reportOnFiles[${key}]}
    done

    exit 0
fi

# TASK 2

if [[ $1 = '-t 2' ]]; then

    shift
    numberA=$1
    numberB=$2

    if [[ ! ${numberA} =~ ^[1-9][0-9]*$ ]]; then
        echo "First integer wrongly specified!" >&2; exit 1
    fi
    if [[ ! ${numberB} =~ ^[1-9][0-9]*$ ]]; then
        echo "Second integer wrongly specified!">&2; exit 2
    fi

    # Find prime factorisation and store it in (sparse) arrays:
    #     index -> as factor
    #   content -> as power of the factor
    numberA_factors=()
    numberB_factors=()
    tmpFactors=( $(factor ${numberA}) )
    # In the following for, skip first entry of array which is 'number:' (see factor command)
    for factor in ${tmpFactors[@]:1}; do
        # unset entries referred without $ are 0 in arithmetic expansion
        numberA_factors[factor]=$(( numberA_factors[factor]+1 ))
    done
    tmpFactors=( $(factor ${numberB}) )
    for factor in ${tmpFactors[@]:1}; do
        numberB_factors[factor]=$(( numberB_factors[factor]+1 ))
    done

    # Collect common factors in arrays with the same logic as above
    # taking largest or smallest exponent for GCD and LCM, respectively
    lcm_factors=()
    gcd_factors=()
    for factor in ${!numberA_factors[@]}; do
        if [[ -v numberB_factors[factor] ]]; then
            if [[ numberA_factors[factor] -gt numberB_factors[factor] ]]; then
                gcd_factors[factor]=${numberB_factors[factor]}
                lcm_factors[factor]=${numberA_factors[factor]}
            else
                gcd_factors[factor]=${numberA_factors[factor]}
                lcm_factors[factor]=${numberB_factors[factor]}
            fi
            #Unset to remain with not common factors for lcm
            unset -v 'numberA_factors[factor]' 'numberB_factors[factor]'
        fi       
    done

    #Final logic: calculate result
    gcd=1
    for factor in ${!gcd_factors[@]}; do
        gcd=$(( gcd * factor**gcd_factors[factor] ))
    done
    lcm=1
    for factor in ${!lcm_factors[@]}; do
        lcm=$(( lcm * factor**lcm_factors[factor] ))
    done
    for factor in ${!numberA_factors[@]}; do
        lcm=$(( lcm * factor**numberA_factors[factor] ))
    done
    for factor in ${!numberB_factors[@]}; do
        lcm=$(( lcm * factor**numberB_factors[factor] ))
    done

    echo
    echo "  GCD(${numberA}, ${numberB})=${gcd}"
    echo "  LCM(${numberA}, ${numberB})=${lcm}"
    echo

    exit 0
fi
