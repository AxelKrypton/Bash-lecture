#!/usr/bin/env bash

if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    printf "\n ERROR: File \"${BASH_SOURCE[0]}\" cannot be executed!\n\n"
    exit 1
fi

#If session is interactive do some useful binding
if [[ -t 1 ]]; then
    #To bind CTRL+up and CTRL-down to previous and following
    # command in history, what usually up and down do
    bind '"\e[1;5A": previous-history'
    bind '"\e[1;5B": next-history'
    #To bind up and down arrow to search in history
    # (anything containing what typed)
    bind '"\e[A": history-substring-search-backward'
    bind '"\e[B": history-substring-search-forward'
fi
