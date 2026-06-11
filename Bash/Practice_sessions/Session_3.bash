#!/usr/bin/env bash

# BONUS: Deal with helper and exit if user asked it
for option in "$@"; do
    if [[ ${option} =~ ^-(h|-help)$ ]]; then
        printf '\n'
        printf '\e[96m%-15s -> %s\e[0m\n' \
               '-h | --help' 'Get this helper message' \
               '-t [VALUE...]' 'Run the provided tests (with no VALUE, display tests and exit)' \
               '-v | --verbose' 'Print tests output also to the terminal'
        printf '\n'
        exit 0
    fi
done

# Let the user pick a test type
select test_type in unit integration system; do
    if [[ ${test_type} =~ ^(unit|integration|system)$ ]]; then
        break
    fi
done

# Store picked files in arrays
readonly tests_folder='tests'
shopt -s nullglob
readonly list_of_tests=( "${tests_folder}"/${test_type}_tests_* )
if [[ ${#list_of_tests[@]} -eq 0 ]]; then
    printf "\n \e[91mERROR: No tests found in '${tests_folder}' folder.\e[0m\n\n"
    exit 1
else
    list_of_tests_names=( "${list_of_tests[@]#*${test_type}_tests_}" )
    list_of_tests_names=( "${list_of_tests_names[@]/%.bash/}" )
    readonly list_of_tests_names
    list_of_selected_tests=()
fi

# Deal with command line options
verbose='FALSE'
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
                while [[ $2 =~ ^[1-9][0-9]*$ ]]; do
                    if [[ $2 -gt ${#list_of_tests_names[@]} ]]; then
                        printf "\n\e[93mWARNING: Not existing test number $2. Ignoring it.\e[0m\n"
                        shift
                        continue
                    fi
                    # Keep this array sparsed in order to be able to retrieve
                    # the full filepath from list_of_tests via the index
                    list_of_selected_tests[$2]="${list_of_tests_names[$2-1]}"
                    shift
                done                
            fi
            shift
            ;;
        -v | --verbose)
            verbose='TRUE'
            shift
            ;;        
        *)
            printf "\n\e[91m ERROR: Option '$1' unrecognised!\e[0m\n\n"
            exit 1
    esac
done

# If no test was selected, run them all
if [[ ${#list_of_selected_tests[@]} -eq 0 ]]; then
    list_of_selected_tests=(
        'fake-0th-entry-to-have-indeces-starting-at-one'
        "${list_of_tests_names[@]}"
    )
    unset -v 'list_of_selected_tests[0]'
fi

# Run tests storing outcome
readonly logfile='tests.log'
printf "\n=== $(date) ===\n\n" >> "${logfile}"
declare -A tests_outcome=()
list_of_failed_tests=()
for index in "${!list_of_selected_tests[@]}"; do
    test_name="${list_of_selected_tests[index]}"
    #----------------------------------------------------------------
    # APPROACH 1:
    #
    # Capturing output and error in a variable can be done, but
    # you need to remember that only standard output is captured
    # by the commands substitution. Furthermore, command subsitution
    # deletes trailing newlines and you have to reintroduce it AFTER
    # having tested the exit code.
    #----------------------------------------------------------------
    # APPROACH 2:
    #
    # Using 'tee -a' is handier but it requires the check on the
    # exit code of the test run, since this is on the left of a
    # pipeline. You need to also pipe standand error into it to
    # have all messsages printed to the terminal and to file.
    # Using a single pipeline then you will loose the distinction
    # between standard error and standard output in the terminal
    # and everything will go to standard output. You can use
    # process substitution to keep that distinction:
    #
    #        bash "${list_of_tests[index-1]}" \
    #           > >(tee -a "${logfile}")      \
    #          2> >(tee -a "${logfile}" >&2)
    # 
    #----------------------------------------------------------------
    # APPROACH 3:
    #
    # Extracting the last block of output from the log file is a bit
    # tricky, but it simplifies the -v option logic a lot. I will
    # implement this in the following. In real life I would use 2.
    #----------------------------------------------------------------
    bash "${list_of_tests[index-1]}" &>> "${logfile}"
    if [[ $? -eq 0 ]]; then
        tests_outcome["${test_name}"]='passed'
    else
        tests_outcome["${test_name}"]='failed'
        list_of_failed_tests+=( "${test_name}" )
    fi
    #----------------------------------------------------------------
    # # APPROACH 1: (declare captured_output='' before the loop)
    # captured_output="$(bash "${list_of_tests[index-1]}" 2>&1)"
    # if [[ $? -eq 0 ]]; then
    #     tests_outcome["${test_name}"]='passed'
    # else
    #     tests_outcome["${test_name}"]='failed'
    #     list_of_failed_tests+=( "${test_name}" )
    # fi
    # printf '%s\n' "${captured_output}" &>> "${logfile}"
    #----------------------------------------------------------------
    # # APPROACH 2:
    # bash "${list_of_tests[index-1]}" |& tee -a "${logfile}"
    # if [[ ${PIPESTATUS[0]} -eq 0 ]]; then
    #     tests_outcome["${test_name}"]='passed'
    # else
    #     tests_outcome["${test_name}"]='failed'
    #     list_of_failed_tests+=( "${test_name}" )
    # fi
    #----------------------------------------------------------------
done

# Extract last block from the log file and print it to the user
if [[ ${verbose} = 'TRUE' ]]; then
    while read -r line; do
        if [[ ${line} =~ ^===.*===$ ]]; then
            break
        fi
        printf "${line}\n"
    done < <(tac "${logfile}") | tac
fi

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
