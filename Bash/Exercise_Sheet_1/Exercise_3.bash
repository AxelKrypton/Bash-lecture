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

printf '%s\n'\
       'When running the script as' ''\
       "   ./script '*.dat' \$(whoami) \"Hello World\"" ''\
       'in a folder with some .dat files, then the script'\
       'still receives only 3 arguments, since filename'\
       'expansion does not expand the *.dat because of'\
       'single quotes. However, using unquoted $* and'\
       '$@, you then give *.dat as unquoted to printf'\
       'and there filename expansion kicks in!'\
       '' ''
