#!/usr/bin/env bash

readonly usage="Usage: $0 GRIDSIZE SITEX SITEY"
readonly logfile='/dev/null'

# Redirect standard output to logfile
exec 3>&1 1>>"${logfile}"

if [[ $# -ne 3 ]]; then
    echo "${usage}" >&2
    exit 1
elif [[ ! $1 =~ ^[1-9][0-9]?x[1-9][0-9]?$ ]]; then
    {
        echo "ERROR: First argument must be the grid size, e.g. 5x8"
        echo "${usage}"
    } >&2
    exit 1
fi

Nx=${1%x*}
Ny=${1#*x}

if [[ ! $2 =~ ^[0-9]+$ || $2 -ge ${Nx} || $2 =~ ^0[0]+$ ]]; then
    {
        echo "ERROR: Second argument must be a valid x index in [0,${Nx})."
        echo "${usage}"
    } >&2
    exit 1
elif [[ ! $3 =~ ^[0-9]+$ || $3 -ge ${Ny} || $3 =~ ^0[0]+$ ]]; then
    {
        echo "ERROR: Third argument must be a valid y index in [0,${Ny})."
        echo "${usage}"
    } >&2
    exit 1
fi

i=$2
j=$3
s=$(( i + j * Nx ))

echo "(${i}, ${j}) -> ${s}"

nn=''   # Next-neighbour pairs
nns=''  # Next-neighbour super-indeces from paris

# Find next-neighbours
for delta_x in -1 0 1; do
    for delta_y in -1 0 1; do
        printf "delta_x = %2s   delta_y = %2s  ->  " "${delta_x}" "${delta_y}"
        if (( delta_x == 0 && delta_y == 0 )); then
            echo "continue (1)"
            continue
        fi
        ip=$(( i + delta_x ))
        jp=$(( j + delta_y ))
        printf "ip = %3s   jp = %3s  ->  " "${ip}" "${jp}"
        if (( ip < 0 || ip >= Nx || jp < 0 || jp >= Ny )); then
            echo "continue (2)"
            continue
        fi
        nn+="(${ip},${jp}) "
        nns+="$(( ip + jp * Nx )) "
        echo "nns = $(( ip + jp * Nx ))"
    done
done

# Remove trailing space from the strings
nn="${nn%}"
nns="${nns%}"

echo "Next-neighbours: ${nn} -> ${nns}"

# Restore standard output to terminal
exec 1>&3 3>&-

# Sort and print next-neighbours
echo "$(printf '%d\n' ${nns} | sort -n | tr '\n' ' ')"
