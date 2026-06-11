#!/usr/bin/env bash

# BONUS: Deal with helper and exit if user asked it
for option in "$@"; do
    if [[ ${option} =~ ^-(h|-help)$ ]]; then
        printf '\n'
        printf '\e[96m%-15s -> %s\e[0m\n' \
               '-h | --help' 'Get this helper message' \
               '-t [VALUE...]' 'Run the provided tests (with no VALUE, display tests and exit)'
        printf '\n'
        exit 0
    fi
done

# If no tests folder exists, create one with some empty tests files in it
readonly tests_folder='tests'
if [[ ! -d "${tests_folder}" ]]; then
    mkdir "${tests_folder}"
    touch "${tests_folder}"/{unit,integration,system}_tests_"$(shuf -n1 /usr/share/dict/words)"_{1..3}.bash
fi

# Let the user pick a test type
select test_type in unit integration system; do
    if [[ ${test_type} =~ ^(unit|integration|system)$ ]]; then
        break
    fi
done

# Store picked files in arrays
readonly list_of_tests=( "${tests_folder}"/${test_type}_tests_* )
list_of_tests_names=( "${list_of_tests[@]#*${test_type}_tests_}" )
list_of_tests_names=( "${list_of_tests_names[@]/%.bash/}" )
readonly list_of_tests_names
list_of_selected_tests=()

# Deal with command line options
while [[ $# -gt 0 ]]; do
    case "$1" in
        -t)
            if [[ $2 =~ ^(-|$) ]]; then
                printf '\n'
                for index in "${!list_of_tests_names[@]}"; do
                    printf '%4d) %s\n' $(( index + 1 )) "${list_of_tests_names[index]}"
                done
                printf '\n'
                exit 0
            else
                while [[ $2 =~ ^[1-9][0-9]?$ ]]; do
                    # Keep this array sparsed in order to be able to retrieve
                    # the full filepath from list_of_tests via the index
                    list_of_selected_tests[$2]="${list_of_tests_names[$2-1]}"
                    shift
                done                
            fi
            shift
            ;;        
        *)
            printf "\n\e[91m ERROR: Option '$1' unrecognised!\e[0m\n\n"
            exit 1
    esac
done

# If no test was selected, run them all
list_of_selected_tests=(
    'fake-0th-entry-to-have-indeces-starting-at-one'
    "${list_of_tests_names[@]}"
)
unset -v 'list_of_selected_tests[0]'

# "Run" tests storing outcome
declare -A tests_outcome=()
list_of_failed_tests=()
for test_name in "${list_of_selected_tests[@]}"; do
    outcome=$(( (RANDOM % 6 + 1) % 2 ))
    if [[ ${outcome} -eq 0 ]]; then
        tests_outcome["${test_name}"]='passed'
    else
        tests_outcome["${test_name}"]='failed'
        list_of_failed_tests+=( "${test_name}" )
    fi
done

# Print report
readonly test_field_length=40
declare -rA color=(
    ['failed']='\e[91m'
    ['passed']='\e[92m'
)
printf '\n'
for index in "${!list_of_selected_tests[@]}"; do
    test_name="${list_of_selected_tests[index]} "
    for (( i=${#test_name}; i<test_field_length; i++ )); do
        test_name+="."
    done
    outcome="${tests_outcome[${list_of_selected_tests[index]}]}"
    
    printf "%4d - %s  ${color[${outcome}]}%s\e[0m\n" \
           ${index} \
           "${test_name}" \
           "${outcome}"
done
printf "\nRun %d test(s): ${color[passed]}%d\e[0m passed ${color[failed]}%d\e[0m failed\n" \
       ${#list_of_selected_tests[@]} \
       $(( ${#list_of_selected_tests[@]} - ${#list_of_failed_tests[@]} )) \
       ${#list_of_failed_tests[@]}

if [[ ${#list_of_failed_tests[@]} -gt 0 ]]; then
    printf '\nThe following tests failed:\n'
    printf "  - ${color[failed]}%s\e[0m\n" "${list_of_failed_tests[@]}"
    printf '\e[0m'
fi
printf '\n'
