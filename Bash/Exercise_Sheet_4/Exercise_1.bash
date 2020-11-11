#!/usr/bin/env bash

# Use logger
source ../Exercise_Sheet_3/Exercise_4.bash || exit 2

function Simulate()
{
    local index
    for (( index=0; index<10; index++ )); do
        echo "In ${FUNCNAME}: index=${index} "
        # (( index==7 )) && return 1
        sleep 3
    done
}

function Monitor()
{
    local simulationPid sleepTime
    simulationPid="$1"
    sleepTime="$2"
    while kill -0 "${simulationPid} " 2> /dev/null ; do
        echo "Simulation still running, sleeping ${sleepTime}s..."
        sleep "${sleepTime}"
        return 2
    done
}

# Invoke both functions in background
echo
Simulate &
pidSimulation=$!
Monitor "${pidSimulation}" 5 &
pidMonitor=$!

wait -n # Wait for the first process to finish
errorCode=$?
echo

if kill -0 "${pidSimulation}" 2>/dev/null && kill -0 "${pidMonitor}" 2>/dev/null; then
    PrintFatal  "Some child process finished, but neither \"Simulate\" nor \"Monitor\"!"
elif kill -0 "${pidSimulation}" 2>/dev/null; then
    PrintError "\"Monitor\" mechanism failed, terminating \"Simulate\" and exiting..."
    kill "${pidSimulation}"
    PrintFatal '\"Simulate\" aborted due to failure in \"Monitor\".'
elif kill -0 "${pidMonitor}" 2>/dev/null; then
    if [[ ${errorCode} -eq 0 ]]; then
        PrintInfo "\"Simulate\" exited, wait \"Monitor\" mechanism to finish..."
    else
        PrintError "\"Simulate\" failed, wait \"Monitor\" mechanism to finish..."
    fi
    wait "${pidMonitor}"
    errorCodeMonitor=${?}
    PrintInfo "\"Monitor\"  exit code: ${errorCodeMonitor}"\
              "\"Simulate\" exit code: ${errorCode}"
    if [[ ${errorCodeFirst} -ne 0 ]] || [[ ${errorCodeSecond} -ne 0 ]]; then
        PrintFatal '\"Monitor\" and/or \"Simulate\" failed.'
    fi
else
    PrintInfo 'Both processes finished almost concurrently.'\
              "The first of the two terminated with exit code ${errorCode}."
fi
