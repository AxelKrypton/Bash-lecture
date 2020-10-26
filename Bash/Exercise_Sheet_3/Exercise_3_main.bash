#!/usr/bin/env bash

# Source the functions
for index in {1..3}; do
    source Exercise_3.${index}.bash
done

#--------------------------------------
# Task 1
filename=''
beta=''
verbose='FALSE'
sizes=()
aspectRatios=()
rangeMin=''
rangeMax=''
walltime=''
files=()

echo -e "\nOptions passed to the script: \e[96m$@\e[0m"
ParseCommandLineOptions "${@}"
echo
printf "  %20s:  %s\n"\
       'filename' "${filename}"\
       'beta' "${beta}"\
       'verbose' "${verbose}"\
       'rangeMin' "${rangeMin}"\
       'rangeMax' "${rangeMax}"\
       'walltime' "${walltime}"\
       'sizes' "${sizes[*]}"\
       'aspectRatios' "${aspectRatios[*]}"\
       "${#files[@]} files" "${files[*]}"
echo

#--------------------------------------
# Task 2
array=( "first element"  $'to be\nfound'  "something" )
strings=( $'to be\nfound' "notExisting" )
for index in "${!array[@]}"; do
    echo "array[${index}]=${array[index]}"
done
echo
for string in "${strings[@]}"; do
    if IsElementIn "${string}" "${array[@]}"; then
        printf '\e[92mString "%s" found in array!\n\n\e[0m'  "${string}"
    else
        printf '\e[91mString "%s" NOT found in array!\n\n\e[0m'  "${string}"
    fi
done

#--------------------------------------
# Task 3
x=160
y=64
CalculateGreatestCommonDivisor ${x} ${y}
printf '  %s(%d,%d) = %d\n'\
       'GCD' "${x}" "${y}" "${result_GCD}"\
       'LCM' "${x}" "${y}" "$(GetLowestCommonMultiple ${x} ${y})"
echo 
