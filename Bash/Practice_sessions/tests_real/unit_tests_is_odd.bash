function Source_Codebase_Functions()
{
    source "${GBL_codebase_folder}/is_odd.bash" || exit 1
}

function Unit_Test__is-odd-1()
{
    Source_Codebase_Functions
    local number
    for number in -17 111 +3423 21325; do
        Call_Codebase_Function_In_Subshell Is_Odd ${number}
        if [[ $? -ne 0 ]]; then
            echo "Number ${number} not detected as odd" >&2
            return 1
        fi
    done
    return 0
}

function Unit_Test__is-odd-2()
{
    Source_Codebase_Functions
    local number
    for number in -42 0 +222 344 21326; do
        Call_Codebase_Function_In_Subshell Is_Odd ${number}
        if [[ $? -ne 1 ]]; then
            echo "Number ${number} not detected as even" >&2
            return 1
        fi
    done
    return 0
}

function Unit_Test__is-odd-3()
{
    Source_Codebase_Functions
    local string
    for string in "abc" "1.5" "+-3" "0x1A"; do
        Call_Codebase_Function_In_Subshell Is_Odd ${string}
        if [[ $? -ne 42 ]]; then
            echo "String '${string}' not detected as invalid input" >&2
            return 1
        fi
    done
    return 0
}

# Utility functions for unit tests.
#
# IMPORTANT NOTE: These should be defined in the main script and not in the test
# files, but if we want to keep the option to run tests files independently, we
# need to e.g. define them here. Clearly, this does not scale and it is done so
# here only for demonstration purposes. In a real project, I would either give up
# on keeping both functions as tests and files as tests (-f option in runner) or
# I'd define these utility functions in a separate file and source it both in
# the main script and in the test files in the "running section", i.e. the in
# the if [[ "${BASH_SOURCE[0]}" == "${0}") ]].
#
function Call_Codebase_Function_In_Subshell()
{
    (Call_Codebase_Function_As_Desired "$@")
}

function Call_Codebase_Function()
{
    Call_Codebase_Function_As_Desired "$@"
}

function Call_Codebase_Function_As_Desired()
{
    # Set stricter bash mode to run codebase code in the mode it is supposed to be run
    set -o errexit
    shopt -s inherit_errexit
    local name_of_the_function="${1-}"
    shift
    if [[ "$(type -t ${name_of_the_function})" = 'function' ]]; then
        ${name_of_the_function} "$@"
    else
        printf "\n \e[91mERROR: Function '${name_of_the_function}' not found!\e[0m\n\n"
    fi
    # Switch off errexit bash mode to handle errors in a standard way inspecting $?
    set +o errexit
    shopt -u inherit_errexit
}

function combine_tests()
{
    local index exit_code=0
    for index in {1..3}; do
        Unit_Test__is-odd-${index}
        (( exit_code += $? ))
    done
    return $exit_code
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    GBL_codebase_folder=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
    combine_tests
fi