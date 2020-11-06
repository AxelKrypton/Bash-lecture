#!/usr/bin/env bash

shopt -s extglob

#mkdir 'temporaryFolder'
#cd 'temporaryFolder'
#touch file{1..20}{.{dat,png,txt},\ backup.dat,_bkp.png}

printf '\nList only files with the .dat extension:\n\n'
ls *.dat

printf '\nList only files with number 13 in the name:\n\n'
ls *[^1-9]13[^[:digit:]]*

printf '\nList only backup files:\n\n'
ls *backup* *bkp*

printf '\nList all but backup files:\n\n'
ls !(*backup*|*bkp*)

printf '\nList only files containing a space in the name:\n\n'
ls *\ * # or: ls *' '*

printf '\nList all but files containing a space in the name:\n\n'
ls !(*' '*)

printf '\nList files with a number that is multiple of 5 before the dot:\n\n'
ls *[05].*
printf '\n'

# Rename the files containing a space replacing it by an underscore:
rename ' ' '_' *\ *

# Change the _bkp.png suffix into _backup.png
rename '_bkp.png' '_backup.png' *_bkp.png

# Add a leading 0 to numbers in files whose name contains a number smaller than 10
rename 'file' 'file0' file?.*

printf '\nBonus problem:\n\n'
printf '%s\n' {0,1}{0,1}{0,1}{0,1}{0,1}{0,1}{0,1}{0,1}
printf '\n'

#cd ..
