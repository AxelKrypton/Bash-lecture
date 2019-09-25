function IsElementIn()
{
    local elementToBeMatched arrayElement
    elementToBeMatched="$1"
    shift
    for arrayElement; do # implicitly iterates over "$@"
        [[ "${elementToBeMatched}" == "${arrayElement}" ]] && return 0
    done
    return 1
}
