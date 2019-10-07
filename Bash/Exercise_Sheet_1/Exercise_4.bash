#!/usr/bin/env bash

echo

printf '  %s\n'\
       'Probably 4 or 8 bytes are used for integers. Computers use bits and therefore base 2.'\
       'Let us calculate some power of 2.'\
       ''\
       "   \$(( 2**31 )) = $(( 2**31 ))"\
       "   \$(( 2**32 )) = $(( 2**32 ))"\
       "   \$(( 2**33 )) = $(( 2**33 ))"\
       '   ...'\
       '   Ok, more than 32 bits, maybe 64'\
       '   ...'\
       "   \$(( 2**61 )) = $(( 2**61 ))"\
       "   \$(( 2**62 )) = $(( 2**62 ))"\
       "   \$(( 2**63 )) = $(( 2**63 ))"\
       "   \$(( 2**64 )) = $(( 2**64 ))"\
       ''\
       'Bingo! Then 64 bits are used and one bit is used for the sign.'\
       'If so, the following should be the maximum integer that Bash handles:'\
       ''\
       "   \$(( 2**63-1 )) = $(( 2**63-1 ))"\
       ''\
       'So we have that 2**63-1 is represented in base 2 as all bits to 1 except'\
       'the sign bit to 0. Probably, the number in base 10 is converted to base 2'\
       'and the last 64 bits are used (the first is the sign-bit). This would explain'\
       'why 2**63 is negative (in base 2 it is 1 followed by 63 zeroes) and also why'\
       '2**64 is 0 (in base 2, 64 is composed by 65 digits: it is 1 followed by 64 zeroes'\
       'and this makes Bash use the last 64 digits that are only zeroes).'\
       ''\
       ''\
       'From the Bash manual it is clear that Bash can deal with bases between 2 and 64.'\
       'For a base larger than 10, letters are used to represent numbers larger than 9.'\
       'In this way one can handle numbers till base 36 (10 digits and 26 letters). It'\
       'does not matter if a letter is upper-case or lower-case. However, to handle bases'\
       'between 37 and 62, 26 new symbols are needed and upper-case letters are used and,'\
       'hence, counting become "case-sensitive". Therefore,'\
       "   \$(( 36#a )) = $(( 36#a )) == \$(( 36#A )) = $(( 36#A ))"\
       'but, instead,'\
       "   \$(( 37#a )) = $(( 37#a )) != \$(( 37#A )) = $(( 37#A ))"\
       ''\
       ''\
       'The base 63 and 64 need two further symbols and Bash uses @ and _ in this order.'\
       'Thus, _ in base 64 translates to 63 in base 10 which is 3f in base 16 and 77 in base 8,'\
       'as shown by the printf command:'\
       ''

printf "     %d %x %o\n" $(( 64#_ )) $(( 64#_ )) $(( 64#_ ))

echo
