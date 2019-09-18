#!/bin/bash

printf '\nScript run with %d argument(s)\n' "$#"

IFS=":${IFS}"

printf 'Using "$@":'
printf ' <%s>' "$@"
printf '\n'

printf 'Using  $@ :'
printf ' <%s>' $@
printf '\n'

printf 'Using "$*":'
printf ' <%s>' "$*"
printf '\n'

printf 'Using  $* :'
printf ' <%s>' $*
printf '\n\n'
