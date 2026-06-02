#!/usr/bin/env bash

msg='$ZKY@Dq_i7_BY@H4ND$iN$7QN@MiNU73S_ZKqN_YqU$C4N_4U7QM473_i7!iN_7QN!HqURS?%%%'
printf '\n%-26s ->  %s\n\n' 'Begin' "${msg}"

# TASK 1

msg="${msg/%%%%/}"
printf "%-26s ->  %s\n\n" 'msg="${msg/%%%%/}"' "${msg}"

# TASK 2

msg="${msg/$/}"
printf "%-26s ->  %s\n\n" 'msg="${msg/$/}"' "${msg}"

# TASK 3

msg="${msg//ZK/WH}"
printf "%-26s ->  %s\n\n" 'msg="${msg//ZK/WH}"' "${msg}"

# TASK 4

msg="${msg//[qQ]N/EN}"
printf "%-26s ->  %s\n\n" 'msg="${msg//[qQ]N/EN}"' "${msg}"

# TASK 5

msg="${msg//4/A}"
printf "%-26s ->  %s\n\n" 'msg="${msg//4/A}"' "${msg}"

# TASK 6

msg="${msg//73/7E}"
printf "%-26s ->  %s\n\n" 'msg="${msg//73/7E}"' "${msg}"

# TASK 7

msg="${msg//[_\!@$]/ }"
printf "%-26s ->  %s\n\n" 'msg="${msg//[_\!@$]/ }"' "${msg}"

# TASK 8

msg="${msg,,}"
printf "%-26s ->  %s\n\n" 'msg="${msg,,}"' "${msg}"

# TASK 9

msg="${msg^}"
printf "%-26s ->  %s\n\n" 'msg="${msg^}"' "${msg}"

# TASK 10

msg="${msg//7/t}"
printf "%-26s ->  %s\n\n" 'msg="${msg//7/t}"' "${msg}"
msg="${msg//q/o}"
printf "%-26s ->  %s\n\n" 'msg="${msg//q/o}"' "${msg}"
