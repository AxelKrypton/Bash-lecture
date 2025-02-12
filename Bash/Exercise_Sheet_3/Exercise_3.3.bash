function CalculateGreatestCommonDivisor()
{
    # Ensure the first number passed is the largest number
    if (( $1 < $2 )); then
        set -- $2 $1
    fi
    local x y
    x="$1"; y="$2"
    if true; then # Euclid's algorithm -> exercise
        if (( x == y )); then
            result_GCD=${x}
        else
            CalculateGreatestCommonDivisor $((x-y)) ${y}
        fi
    else # Euclidean algorithm -> more efficient
        if (( y == 0 )); then
            result_GCD=${x}
        else
            CalculateGreatestCommonDivisor ${y} $((x%y))
        fi
    fi
}

function GetLowestCommonMultiple()
{
    local x y
    x="$1"; y="$2"
    CalculateGreatestCommonDivisor ${x} ${y}
    echo $(( x*y/result_GCD ))
}
