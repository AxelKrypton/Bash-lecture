#!/usr/bin/env bash

# If no tests folder exists, create one with some empty tests files in it
readonly tests_folder='tests'
if [[ ! -d "${tests_folder}" ]]; then
    mkdir "${tests_folder}"
    touch "${tests_folder}"/{unit,integration,system}_tests_"$(shuf -n1 /usr/share/dict/words)"_{1..3}.bash
fi

# Let the user pick a test type
select test_type in unit integration system; do
    if [[ ${test_type} =~ ^(unit|integration|system)$ ]]; then
        break
    fi
done

# Count how many tests will be "run"
counter=0
for test_file in "${tests_folder}"/${test_type}_tests_*; do
    counter=$(( counter + 1 ))
done

# "Run" tests and print report
index=1
readonly test_field_length=40
printf '\n'
for test_file in "${tests_folder}"/${test_type}_tests_*; do
    test_name="${test_file#*${test_type}_tests_}"
    test_name="${test_name/%.bash/}"
    test_name+=" "
    for (( i=${#test_name}; i<test_field_length; i++ )); do
        test_name+="."
    done
    test_outcome=$(( (RANDOM % 6 + 1) % 2 ))
    if [[ ${test_outcome} -eq 0 ]]; then
        test_outcome='passed'
    else
        test_outcome='failed'
    fi
    printf "%2d/%d   %s  %s\n" \
           ${index} ${counter} \
           "${test_name}"      \
           "${test_outcome}"
    index=$(( index + 1 ))
done
printf '\n'


