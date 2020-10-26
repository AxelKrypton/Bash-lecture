function CalculateGreatestCommonDivisor()
{
    local x y
    x="$1"; y="$2"
    if (( y==0 )); then
        result_GCD=${x}
    else
        CalculateGreatestCommonDivisor ${y} $((x%y))
    fi
}

function GetLowestCommonMultiple()
{
    local x y
    x="$1"; y="$2"
    CalculateGreatestCommonDivisor ${x} ${y}
    echo $(( x*y/result_GCD ))
}
