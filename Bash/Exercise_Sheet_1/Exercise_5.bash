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

#To avoid the temporary variable you need more knowledge, e.g. arrays
# NOTE: Parameter expansion cannot be nested!
temporaryString=${stringToParse%_*}
firstField=${temporaryString%_*}
secondField=${temporaryString#*_}
postfix=${stringToParse##*_}

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
