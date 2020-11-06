#!/usr/bin/env bash

if [[ $# -ne 1 || ! $1 =~ ^[0-9]+$ ]]; then
    printf '\n\e[91m Call this script with a non negative integer a unique command line argument.\e[0m\n\n'
    exit 1
fi

#TASK 1

{
    echo "THERMALIZE=1"
    if (( $1 % 4 == 0)); then
        echo "USE_HMC"
    else
        echo "USE_RHMC"
    fi
    echo "DO_BACKUP=0"
} > File_command_block.dat


#TASK 2

exec 3>&1 1> File_exec.dat

echo "THERMALIZE=1"
if (( $1 % 4 == 0)); then
    echo "USE_HMC"
else
    echo "USE_RHMC"
fi
echo "DO_BACKUP=0"

exec 1>&3 3>&-

#TASK 3

label="USE_RHMC"
if (( $1 % 4 == 0)); then
    label="USE_HMC"
fi
cat > File_Heredoc.dat <<HERE_DOC
THERMALIZE=1
${label}
DO_BACKUP=0
HERE_DOC

# Show that files are the same and remove them
head 'File_command_block.dat' 'File_exec.dat' 'File_Heredoc.dat'
rm 'File_command_block.dat' 'File_exec.dat' 'File_Heredoc.dat'
