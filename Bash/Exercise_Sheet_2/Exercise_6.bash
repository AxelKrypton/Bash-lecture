#!/usr/bin/env bash

{ echo "I'm stdout"; echo "I'm stderr" >&2; } 3>&1 1>&2 2>&3 3>&- | rev

# This would also work but would leave the fd 3 open in the compund command {...}
#
#  { echo "I'm stdout"; echo "I'm stderr" >&2; } 3>&1 1>&2 2>&3 | rev

