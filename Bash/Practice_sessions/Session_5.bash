#!/usr/bin/env bash

function Main()
{
    Enable_Desired_Shell_Behaviour
    Define_Global_Variables
    Print_Helper_And_Exit_If_Requested "$@"
    Parse_Type_Of_Tests "$1"
    Define_Available_Tests
    Parse_Command_Line_Parameters "${@:2}"
    Run_Tests
    Print_Tests_Report
    Exit_With_Tests_Outcome_Dependent_Exit_Code
}

function Enable_Desired_Shell_Behaviour()
{
    shopt -s nullglob
}

function Define_Global_Variables()
{
    readonly GBL_tests_folder='tests_sleep'
    GBL_tests_type=''
    GBL_concurrency_number=1
    GBL_verbose='FALSE'
    GBL_list_of_tests=()
    GBL_list_of_selected_tests=()
    declare -gA GBL_tests_outcome=()
    GBL_list_of_failed_tests=()
}

function Print_Helper_And_Exit_If_Requested()
{
    for option in "$@"; do
        if [[ ${option} =~ ^-(h|-help)$ ]]; then
            printf '\n \e[93mUSAGE: %s TYPE [options...]\e[0m\n\n        %s\n\n' \
                   "${BASH_SOURCE[0]}" \
                   'TYPE can be either "unit" or "integration" or "system".'
            printf '    \e[96m%-15s -> %s\e[0m\n' \
                   '-h | --help' 'Get this helper message' \
                   '-t [VALUE...]' 'Run the provided tests (with no VALUE, display tests and exit)' \
                   '-j VALUE' 'Run VALUE tests concurrently (default: ${GBL_concurrency_number})' \
                   '-v | --verbose' 'Print tests output also to the terminal'
            printf '\n'
            exit 0
        fi
    done
}

function Parse_Type_Of_Tests()
{
    if [[ $1 =~ ^(unit|integration|system)$ ]]; then
        readonly GBL_tests_type="$1"
    else
        printf "\n \e[91mERROR: First positional argument must be either 'unit' or 'integration' or 'system'.\e[0m\n\n"
        exit 1
    fi
}

function Define_Available_Tests()
{
    readonly GBL_list_of_tests=( "${GBL_tests_folder}"/${GBL_tests_type}_tests_* )
    if [[ ${#GBL_list_of_tests[@]} -eq 0 ]]; then # Assume nullglob enabled
        printf "\n \e[91mERROR: No tests found in '${tests_folder}' folder.\e[0m\n\n"
        exit 1
    else
        GBL_list_of_tests_names=( "${GBL_list_of_tests[@]#*${GBL_tests_type}_tests_}" )
        GBL_list_of_tests_names=( "${GBL_list_of_tests_names[@]/%.bash/}" )
        readonly GBL_list_of_tests_names
    fi
}

function Parse_Command_Line_Parameters()
{
    while [[ $# -gt 0 ]]; do
        case "$1" in
            -t)
                if [[ $2 =~ ^(-|$) ]]; then
                    printf '\n'
                    for index in "${!GBL_list_of_tests_names[@]}"; do
                        printf '%4d) %s\n' $(( index + 1 )) "${GBL_list_of_tests_names[index]}"
                    done
                    printf '\n'
                    exit 0
                else
                    while [[ $2 =~ ^[1-9][0-9]*$ ]]; do
                        if [[ $2 -gt ${#GBL_list_of_tests_names[@]} ]]; then
                            printf "\n\e[93mWARNING: Not existing test number $2. Ignoring it.\e[0m\n"
                            shift
                            continue
                        fi
                        # Keep this array sparsed in order to be able to retrieve
                        # the full filepath from GBL_list_of_tests via the index
                        GBL_list_of_selected_tests[$2]="${GBL_list_of_tests_names[$2-1]}"
                        shift
                    done                
                fi
                shift
                ;;
            -j)
                if [[ $2 =~ ^[1-9][0-9]*$ ]]; then
                    GBL_concurrency_number="$2"
                else
                    printf "\n\e[91m ERROR: Option '-j' requires a positive integer as argument.\e[0m\n\n"
                    exit 1
                fi
                shift 2
                ;;
            -v | --verbose)
                GBL_verbose='TRUE'
                shift
                ;;        
            *)
                printf "\n\e[91m ERROR: Option '$1' unrecognised!\e[0m\n\n"
                exit 1
        esac
    done
    if [[ ${#GBL_list_of_selected_tests[@]} -eq 0 ]]; then
        GBL_list_of_selected_tests=(
            'fake-0th-entry-to-have-indeces-starting-at-one'
            "${GBL_list_of_tests_names[@]}"
        )
        unset -v 'GBL_list_of_selected_tests[0]'
    fi
    if [[ ${GBL_concurrency_number} -gt ${#GBL_list_of_selected_tests[@]} ]]; then
        printf "\n\e[93mWARNING: Asked to run ${GBL_concurrency_number} tests concurrent, but there are only ${#GBL_list_of_selected_tests[@]} tests to be run.\e[0m\n"
        GBL_concurrency_number=${#GBL_list_of_selected_tests[@]}
    fi
    readonly GBL_list_of_selected_tests GBL_concurrency_number GBL_verbose
}

function Run_Tests()
{
    local -r logfile='tests.log'
    printf "\n=== $(date) ===\n\n" >> "${logfile}"
    local index line
    if [[ ${GBL_concurrency_number} -eq 1 ]]; then
        local test_name
        for index in "${!GBL_list_of_selected_tests[@]}"; do
            test_name="${GBL_list_of_selected_tests[index]}"
            printf " Running test %2d: %s\r" \
                "$(( index ))" \
                "${GBL_list_of_selected_tests[index]}"
            Run_Single_Test "${GBL_list_of_tests[index-1]}"
            Set_Test_Outcome "${test_name}" $?
        done
    else
        if [[ $(sort -V <<< $'${BASH_VERSINFO[0]}.${BASH_VERSINFO[1]}\n5.0' | tail -n1) = '5.0' ]]; then
            printf "\n \e[91mERROR: Bash version 5.1 or more recent needed to run concurrent jobs, Bash ${BASH_VERSION} in use.\e[0m\n\n"
            exit 1
        fi
        local background=0 finished=0 pid_to_test_name=()
        for index in "${!GBL_list_of_selected_tests[@]}"; do
            Run_Single_Test "${GBL_list_of_tests[index-1]}" &
            pid_to_test_name[$!]="${GBL_list_of_selected_tests[index]}"
            (( background++ ))
            if [[ ${background} -eq ${GBL_concurrency_number} ]]; then
                Wait_For_A_Single_Test_To_Finish
            fi
        done
        # Wait for the remaining background tests to finish
        while [[ ${background} -gt 0 ]]; do
            Wait_For_A_Single_Test_To_Finish
        done
    fi
    printf '\r\e[K'
    if [[ ${GBL_verbose} = 'TRUE' ]]; then
        # Extract last block from the log file and print it to the user
        while read -r line; do
            if [[ ${line} =~ ^===.*===$ ]]; then
                break
            fi
            printf "${line}\n"
        done < <(tac "${logfile}") | tac
    fi
    readonly GBL_list_of_failed_tests
}

function Run_Single_Test()
{
    local test_file="$1"
    bash "${test_file}" &>> "${logfile}"
    return $? # Unnecessary, but makes it more explicit that the exit code of the test is the exit code of this function
}

function Wait_For_A_Single_Test_To_Finish()
{
    # This function assumes 'pid_to_test_name', 'background' and 'finished' are set from the calling scope
    local pid status test_name
    wait -n -p pid
    status=$?
    test_name="${pid_to_test_name[pid]}"
    Set_Test_Outcome "${test_name}" "${status}"
    (( background-- ))
    (( finished++ ))
    unset -v 'pid_to_test_name[pid]'
    printf "\r Tests done %2d/%d" "${finished}" "${#GBL_list_of_selected_tests[@]}"
}

function Set_Test_Outcome()
{
    local test_name="$1" status="$2"
    if [[ ${status} -eq 0 ]]; then
        GBL_tests_outcome["${test_name}"]='passed'
    else
        GBL_tests_outcome["${test_name}"]='failed'
        GBL_list_of_failed_tests+=( "${test_name}" )
    fi
}

function Print_Tests_Report()
{
    local -r test_field_length=40
    declare -rA color=(
        ['failed']='\e[91m'
        ['passed']='\e[92m'
    )
    local index test_name outcome
    printf '\n'
    for index in "${!GBL_list_of_selected_tests[@]}"; do
        test_name="${GBL_list_of_selected_tests[index]} "
    for (( i=${#test_name}; i<test_field_length; i++ )); do
        test_name+="."
    done
    outcome="${GBL_tests_outcome[${GBL_list_of_selected_tests[index]}]}"    
    printf "%4d - %s  ${color[${outcome}]}%s\e[0m\n" \
           ${index} \
           "${test_name}" \
           "${outcome}"
    done
    printf "\nRun %d test(s): ${color[passed]}%d\e[0m passed ${color[failed]}%d\e[0m failed\n" \
           ${#GBL_list_of_selected_tests[@]} \
           $(( ${#GBL_list_of_selected_tests[@]} - ${#GBL_list_of_failed_tests[@]} )) \
           ${#GBL_list_of_failed_tests[@]}
    if [[ ${#GBL_list_of_failed_tests[@]} -gt 0 ]]; then
        printf '\nThe following tests failed:\n'
        printf "  - ${color[failed]}%s\e[0m\n" "${GBL_list_of_failed_tests[@]}"
        printf '\e[0m'
    fi
    printf '\n'
}

function Exit_With_Tests_Outcome_Dependent_Exit_Code()
{
    local number="${#GBL_list_of_failed_tests[@]}"
    if [[ ${number} -gt 255 ]]; then
        printf "\n\e[93mWARNING: More than 255 tests failed. Use 255 as exit code.\e[0m\n\n"
        number=255
    fi
    exit ${number}
}

Main "$@"

# --------------------------------------------------------
# Proof of concept for pool of workers for Bash before 5.1
# --------------------------------------------------------
# #!/usr/bin/env bash
# 
# maxjobs=4
# 
# fifo=$(mktemp -u)
# mkfifo "$fifo"
# 
# exec 3<>"$fifo"
# rm "$fifo"
# 
# declare -A task_of
# 
# run_job() {
#     local task=$1
# 
#     (
#         sleep "$((RANDOM % 5 + 1))"    # simulate work
# 
#         # notify parent that this worker finished
#         printf '%s\n' "$BASHPID" >&3
#     ) &
# 
#     task_of[$!]=$task
# }
# 
# reap_one() {
#     local pid
# 
#     read -r pid <&3
#     wait "$pid"
# 
#     printf 'Finished PID %s (task %s)\n' \
#            "$pid" "${task_of[$pid]}"
# 
#     unset 'task_of[$pid]'
#     ((running--))
# }
# 
# tasks=(A B C D E F G H I J)
# 
# running=0
# 
# for task in "${tasks[@]}"; do
#     while (( running >= maxjobs )); do
#         reap_one
#     done
# 
#     run_job "$task"
#     ((running++))
# done
# 
# while (( running > 0 )); do
#     reap_one
# done
# 
# exec 3>&-
# exec 3<&-


