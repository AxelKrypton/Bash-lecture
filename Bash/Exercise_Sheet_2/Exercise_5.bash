#!/usr/bin/env bash

printf "\n\e[1;38;5;202mWelcome to: Find the intruder for robots!\e[93m :)\e[0m\n\n"
while [[ ! ${wordsNumber} =~ ^[1-9][0-9]*$ ]]; do
    printf '\e[96mHow many words would you like to play with? \e[0m'
    read wordsNumber
    if [[ ${wordsNumber} -eq 1 ]]; then
        printf '\n\e[1;4;93mWARNING\e[24m:\e[22m Playing with one word would be cheating!\e[0m\n\n'
        wordsNumber='nonsense' # just to renter the loop
    fi
done


if [[ ${wordsNumber} -gt 10 ]]; then
    printf '\n\e[1;4;93mWARNING\e[24m:\e[22m Maximum allowed number is 10, drawing 10 words.\e[0m\n\n'
    wordsNumber=10
fi

dictionary='/usr/share/dict/words'

while [[ ! -f ${dictionary} ]]; do
    printf 'Dictionary not found! Enter dictonary file path: '
    read dictionary
done

listOfWords=( $(shuf "${dictionary}" -n ${wordsNumber}) )
intruder=${listOfWords[$(shuf -e ${!listOfWords[@]} -n 1)]}

PS3="$(printf '\e[96mWhich is the word not belonging to the group? \e[0m')"
select guess in "${listOfWords[@]}"; do
    if [[ ${guess} = '' ]]; then
        continue
    fi
    if [[ ${guess} != "${intruder}" ]]; then
        printf "\n  \e[91mNO! \e[1;93m${guess}\e[22;91m belongs to the group, retry!\e[0m\n\n"
    else
        printf "\n \e[92mYES! \e[1;96m${guess}\e[22;92m clearly does not belong to the group! You won!\e[0m\n\n"
        break
    fi
done

exit 0
