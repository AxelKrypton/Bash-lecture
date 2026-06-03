#!/usr/bin/env bash

printf '\nInsert words (s|show to show count, r|reset to reset count, q|quit to exit):\n'

declare -A counter

while read -r -p " > " word; do
    words=( ${word} ) # Let word splitting split
    for w in "${words[@]}"; do
        case "${w}" in
            s | show )
                for key in "${!counter[@]}"; do
                    printf "%30s: %d\n" "${key}" "${counter[${key}]}"
                done
                ;;
            r | reset )
                counter=()
                ;;
            q | quit )
                printf '\n'
                exit 0
                ;;
            *)
                counter["${w,,}"]=$(( counter["${w,,}"] + 1 ))
                ;;
        esac
    done
done
