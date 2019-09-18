#!/usr/bin/env bash

echo

a='apple'

printf '%-25s' 'echo "$a"'
echo "$a"

printf '%-25s' "echo '\$a'"
echo '$a'

printf '%-25s' "echo \"'\$a'\""
echo "'$a'"

printf '%-25s' "echo '\"\$a\"'"
echo '"$a"'

printf '%-25s' "echo '\\''"
echo "**INVALID** (can not escape a ' within '')"
#echo '\''          <- this line breaks the code (last quote is not closed!)

printf '%-25s' 'echo "red$arocks"'
echo "red$arocks"

printf '%-25s' 'echo "redapple$"'
echo "redapple$"

printf '%-25s' "echo '\\\"'"
echo '\"'

printf '%-25s' "echo \"\\'\""
echo "\'"

printf '%-25s' 'echo "\""'
echo "\""

printf '%-25s' 'echo "*"'
echo "*"

printf '%-25s' 'echo "\t\n"'
echo "\t\n"

printf '%-25s' 'echo "$(echo hi)"'
echo "$(echo hi)"

printf '%-25s' "echo '\$(echo hi)'"
echo '$(echo hi)'

printf '%-25s' "echo \$'\$a\\''"
echo $'$a\''

printf '%-25s' "echo \"\$'\\t'\""
echo "$'\t'"

echo
