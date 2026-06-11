function Is_Odd()
{
    if [[ ! $1 =~ ^(0|[-+]?[1-9][0-9]*)$ ]]; then
        exit 42
    elif (( $1 % 2 == 0 )); then
        return 1
    else
        return 0
    fi
}