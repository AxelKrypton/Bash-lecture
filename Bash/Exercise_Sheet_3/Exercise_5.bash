#!/usr/bin/env bash

# Use Logger
source Exercise_2.bash || exit 2

inputfile='LQCD.dat'
outputfile='LQCD_processed.dat'

if [[ ! -f "${inputfile}" ]]; then
    PrintFatal "File '${inputfile}' was not found!"
fi

# TASK 1,2,3
echo
for obs in PLAQUETTE fRECTANGLE POLYAKOV; do
    measures="$(grep -c "MEASURE\[[0-9]\+\]::${obs}" ${inputfile})"
    range_tr="$(grep    "MEASURE\[[0-9]\+\]::${obs}" ${inputfile} | sed -n -e 's/.*MEASURE\[\([0-9]\+\)\].*/\1/' -e '1p' -e '$p' | tr '\n' '-')"
    holes_tr="$(grep    "MEASURE\[[0-9]\+\]::${obs}" ${inputfile} | sed 's/.*MEASURE\[\([0-9]\+\)\].*/\1/' | awk 'NR==1{tr=$1; next} NR>1 && $1!=tr+1{printf "%d-%d ", tr, $1; tr=$1; next} {tr=$1}')"
    printf "%15s:  Measures=%d  tr=[%s]  Holes=[%s]\n"\
           "${obs}"\
           "${measures}"\
           "${range_tr%?}"\
           "${holes_tr%?}" 
done
echo

# FINAL PART
plaquette=()
rectangle=()
polyakov=()

while read line; do
    plaquette[${line%|*}]="${line#*|}"
done < <(grep "MEASURE\[[0-9]\+\]::PLAQUETTE" "${inputfile}" | sed 's/.*MEASURE\[\([0-9]\+\)\]::PLAQUETTE[[:space:]]*\(.*\)/\1|\2/')

while read line; do
    rectangle[${line%|*}]="${line#*|}"
done < <(grep "MEASURE\[[0-9]\+\]::fRECTANGLE" "${inputfile}" | sed 's/.*MEASURE\[\([0-9]\+\)\]::fRECTANGLE[[:space:]]*\(.*\)/\1|\2/')

while read line; do
    polyakov[${line%|*}]="${line#*|}"
done < <(grep "MEASURE\[[0-9]\+\]::POLYAKOV" "${inputfile}" | sed 's/.*MEASURE\[\([0-9]\+\)\]::POLYAKOV[[:space:]]*(\([^,]*\),\([^,]*\))/\1|\2   \3/')


# VERY SLOW! Why?
#
# rm -f "${outputfile}"
# for index in ${!plaquette[@]}; do
#     if [[ ${rectangle[index]} != '' ]] && [[ ${polyakov[index]} != '' ]]; then
#         printf "%6d%30s%30s%60s\n"\
#                "${index}"\
#                "${plaquette[index]}"\
#                "${rectangle[index]}"\
#                "${polyakov[index]}" >> "${outputfile}"
#     else
#         PrintWarning "Incomplete measures for tr. ${index}"
#         printf '\e[1A'
#     fi
# done

# Better but still not smart!
#
# exec 3>&1
# for index in ${!plaquette[@]}; do
#     if [[ ${rectangle[index]} != '' ]] && [[ ${polyakov[index]} != '' ]]; then
#         printf "%6d%30s%30s%60s\n"\
#                "${index}"\
#                "${plaquette[index]}"\
#                "${rectangle[index]}"\
#                "${polyakov[index]}" >&3
#     else
#         PrintWarning "Incomplete measures for tr. ${index}"
#         printf '\e[1A'
#     fi
# done 3> "${outputfile}"

exec 3>&1
for index in ${!plaquette[@]}; do
    if [[ ${rectangle[index]} != '' ]] && [[ ${polyakov[index]} != '' ]]; then
        printf "%6d%30s%30s%60s\n"\
               "${index}"\
               "${plaquette[index]}"\
               "${rectangle[index]}"\
               "${polyakov[index]}"
    else
        PrintWarning "Incomplete measures for tr. ${index}" >&3
        printf '\e[1A' >&3
    fi
done > "${outputfile}"

# Holes check
echo
holesProcessed="$(awk 'NR==1{tr=$1; next} NR>1 && $1!=tr+1{printf "%d-%d ", tr, $1; tr=$1; next} {tr=$1}' "${outputfile}")"
PrintInfo "Processed file: Holes=[${holesProcessed%?}]"

# BONUS: Find out all incomplete trajectories
PrintInfo "List of all incomplete trajectories"; printf '\e[1A'
min_max=( $(grep 'MEASURE\[[0-9]\+\]' "${inputfile}" | sed -n -e 's/.*MEASURE\[\([0-9]\+\)\].*/\1/' -e '1p' -e '$p' | tr '\n' ' ') )
for ((index=min_max[0]; index<=min_max[1]; index++)); do
    if [[ ${plaquette[index]} != '' ]] && [[ ${rectangle[index]} != '' ]] && [[ ${polyakov[index]} != '' ]]; then
        continue
    fi
    if [[ ${plaquette[index]} == '' ]] && [[ ${rectangle[index]} == '' ]] && [[ ${polyakov[index]} == '' ]]; then
        continue
    fi
    if [[ ${plaquette[index]} == '' ]] || [[ ${rectangle[index]} == '' ]] || [[ ${polyakov[index]} == '' ]]; then
        PrintWarning "Incomplete measures for tr. ${index}" >&3
        printf '\e[1A' >&3
    fi
done
