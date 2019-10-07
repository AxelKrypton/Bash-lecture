#!/bin/bash

if [[ ! $1 =~ ^-[nf]$ ]]; then
    echo "Error: The first option should be either -n or -f."
    exit 1
fi

if [[ $1 = '-n' ]]; then
    #Numeric mode, check 2 more arguments
    if [[ $# -ne 3 ]]; then
        echo "Error: Numeric mode requires exactly 3 arguments (-n, 2 or 8, and I or II or III)."
        exit 1
    else
        if [[ $2 -ne 2 && $2 -ne 8 ]]; then
            echo "Error: Numeric mode requires either 2 or 8 as second argument."
            exit 1
        fi
        if [[ ! $3 =~ ^[I]{1,3}$ ]]; then
            echo "Error: Numeric mode requires either I or II or III as third argument."
            exit 1
        fi
    fi
    #Implementation
    if [[ $2 -eq 2 ]]; then
        if [[ $3 = I ]]; then
            echo {0,1}
        elif [[ $3 = II ]]; then
            echo {0,1}{0,1}
        else
            echo {0,1}{0,1}{0,1}
        fi
    else
        if [[ $3 = I ]]; then
            echo {0..7}
        elif [[ $3 = II ]]; then
            echo {0..7}{0..7}
        else
            echo {0..7}{0..7}{0..7}
        fi
    fi

elif [[ $1 = '-f' ]]; then
    #File mode, check 1 more argument
    if [[ $# -ne 2 ]]; then
        echo "Error: File mode requires exactly 2 arguments (-f and a three lower-case-characters argument)."
        exit 1
    else
        if [[ ! $2 =~ ^[a-z]{3}$ ]]; then
            echo "Error: File mode requires a three lower-case-characters as second argument."
            exit 1
        fi
    fi
    #Implementation
    echo *.$2
fi


exit 0
