#!/usr/bin/env bash

readonly CPU_busy=1

if [[ ${CPU_busy} -eq 1 ]]; then

    function Burn_Cpu() {
        local iterations=${1:-500000}
        local x=0
        for ((i=0; i<iterations; ++i)); do
            (( x += i ))
        done
    }

else

    function Burn_Cpu() {
        sleep ${1:-2}
    }

fi

function Time_Concurrent_Burn()
{
    local n_concurrent=${1:-1}
    echo "Timing ${n_concurrent} concurrent process(es):"
    time -p {
        for ((i=0; i<${n_concurrent}; i++)); do
            Burn_Cpu &
        done
        wait
    }
}

function Scan_Times()
{
    local real=() user=() sys=()
    for n in "$@"; do
        if [[ ! ${n} =~ ^[1-9][0-9]?$ ]]; then
            echo "Function ${FUNCNAME} should get integer arguments in [1,99]."
            return 1
        fi
    done
    for n in "$@"; do        
        while read -r label duration; do
            [[ "${label}" = '' ]] && continue
            case "${label}" in
                real)
                    real[n]="${duration}"
                    ;;
                user)
                    user[n]="${duration}"
                    ;;
                sys)
                    sys[n]="${duration}"
                    ;;
                *)
                    echo "label=${label} not recognised"
                    ;;
            esac
        done < <(Time_Concurrent_Burn "${n}" 3>&1 1>&2 2>&3)
    done
    printf '\n%6s%15s%15s%15s%15s\n' 'N' 'real' 'user' 'sys' 'user/real'
    for n in "${!real[@]}"; do
        printf '%6d%15s%15s%15s%15s\n' "${n}" "${real[n]}" "${user[n]}" "${sys[n]}" "$(bc -l <<< "scale=3; ${user[n]}/${real[n]}")"
    done
    echo
}

echo ''
read -p 'Do you want to run the scan of times? (Y/N) '
case "${REPLY}" in
    [yY])
        Scan_Times {1..10} 16 32 64
        ;;
    [nN])
        ;;
    *)
        printf 'I consider your answer "%s" as a no.\n\n' "${REPLY}"
        ;;
esac

read -p 'Do you want to see the discussion of the questions in the exercise? (Y/N) '
case "${REPLY}" in
    [yY])
        :
        ;;
    [nN])
        echo ''
        exit 0
        ;;
    *)
        printf 'I consider your answer "%s" as a no.\n\n' "${REPLY}"
        exit 1
        ;;
esac

cat <<'EOF'

============================================================
  Solution discussion (referring to exercise sheet points)
============================================================

1. When a single Burn_Cpu process is executed,

       real ≈ user
       sys  ≈ 0

   because one CPU core performs useful work and very little time is spent
   inside the operating system.

3. Starting two concurrent processes and assuming that two CPU cores are
   available, both jobs are likely to run in parallel. In that case:

       real  ≈ single-process runtime
       user  ≈ 2 × single-process runtime

   because user time is accumulated over all processes. However, note that
   sys time is larger than before, since the shell has to handle the concurrent
   running mechanism.

4. Running approximately as many processes as available CPU cores often gives
   the best utilisation of the machine. A typical observation is:

       real  stays almost constant
       user  grows roughly linearly

5. When the number of processes exceeds the number of available cores, the
   operating system must repeatedly interrupt and reschedule them, time-share
   the cores among multiple jobs. Typical effects are larger sys time and
   diminishing gain. In theory, after having exceeded the number of CPU cores 
   by 1, the real time starts increasing roughly proportionally to
       number of processes/number of cores
   while the total user time continues to grow approximately linearly.

6. See solution code. Note that in my solution I used POSIX output of the time
   keyword (-p option) to be able to the calculate the ratio between user and
   real time (which should roughly be the number of concurrent processes capped
   at the number of available CPU cores). For instance, on a 8-cores laptop a
   possible output might be:

        N           real           user            sys      user/real
        1           1.83           1.75           0.08           .956
        2           1.86           3.48           0.16          1.870
        3           1.95           5.55           0.25          2.846
        4           1.99           7.46           0.34          3.748
        5           2.25          10.63           0.49          4.724
        6           2.51          14.16           0.66          5.641
        7           2.70          17.77           0.84          6.581
        8           2.96          21.41           1.01          7.233
        9           3.31          23.99           1.15          7.247
       10           3.66          26.84           1.28          7.333
       16           5.87          43.02           2.06          7.328
       32          11.92          87.37           4.21          7.329
       64          24.06         177.15           8.53          7.362

   The ratio user/real is a rough estimate of the average number of CPU cores
   simultaneously executing useful work. Once all cores are busy, the ratio
   cannot grow significantly further.

7. Why can the user time be larger than the real time?

     The values reported by 'time' are accumulated over all participating
     processes. For example, with 8 processes and 5 seconds of CPU work each
     gives approximately a user time of ≈40 seconds even if the wall-clock time
     is only about 5 seconds.

   Why does adding more background processes not always reduce execution time?

     First of all it depends what the process does. The Burn_Cpu function in
     this exercise is keeping the CPU core basically 100% busy. An opposite
     example is the sleep command that would leave the CPU core idle (and free
     to do other work in the mean time). If the CPU core are busy, at most
     nproc cores can work in parallel. On the other hand, the less is the CPU
     core load, the more it seems that processes can be "parallelised". If you
     switch the global variable CPU_busy to 0, i.e. use sleep in the Burn_Cpu
     function, then you will see that the real time is almost constant even
     way above the number of CPU cores available. Said differently, the sleep
     version is not CPU-bound. Most of the time is spent waiting, therefore
     hundreds of concurrent sleep processes can coexist without noticeably
     increasing the wall-clock time.

   Does '&' guarantee parallel execution? If not, what does it guarantee?

     Concurrency VS parallelism! The '&' operator guarantees concurrency, i.e.
     the shell does not wait immediately. It does NOT guarantee parallelism.
     Whether two jobs run simultaneously depends on:
       - number of available CPU cores;
       - scheduler decisions;
       - system load.

   What role does the operating system scheduler play in these experiments?

     The operating system scheduler decides:
         - which process runs;
         - on which CPU;
         - for how long.
     The scheduler is therefore responsible for turning concurrency into
     actual parallel execution whenever hardware resources permit.

EOF
