#!/usr/bin/env bash

# TASK 1

#filename='hello.txt'
#${EDITOR:-$(which vim)} "${filename:?Variable filename unset or empty}"

# TASK 2

printf '%35s  %s\n'\
       '' ''\
       'PATH:' "${PATH}"\
       'Highest priority in PATH:' "${PATH%%:*}"\
       'Lowest priority in PATH:' "${PATH##*:}"\
       'All but highest priority in PATH:' "${PATH#*:}"\
       'All but lowest priority in PATH:' "${PATH%:*}"\
       '' ''
       
# TASK 3

#stringToParse="b5.6789_s9876_thermalizeFromHot"
#stringToParse="beta6.0000_seed1111_continueWithNewChain"
stringToParse="beta6.1234_s1234_thermalizeFromConf"

if [[ ${stringToParse} =~ ^([^_]+)_([^_]+)_([^_]+)$ ]]; then
    firstField="${BASH_REMATCH[1]}"   # or firstField="${stringToParse%%_*}"
    secondField="${BASH_REMATCH[2]}"
    postfix="${BASH_REMATCH[3]}"      # or postfix="${stringToParse##*_}"
fi
betaValue=${firstField: -6}
seedValue=${secondField: -4}
betaPrefix=${firstField/${betaValue}}
seedPrefix=${secondField/${seedValue}}

printf '%35s  %s\n'\
       'String:' "${stringToParse}"\
       'Beta prefix:' "${betaPrefix}"\
       'Beta value:' "${betaValue}"\
       'Seed prefix:' "${seedPrefix}"\
       'Seed value:' "${seedValue}"\
       'Postfix:' "${postfix}"\
       '' ''

# TASK 4

printf -v listOfWords '%s_' First Second Third
printf '%35s  %s\n'\
       "listOfWords:" "${listOfWords%?}"\
       '' ''
