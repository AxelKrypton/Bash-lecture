#!/usr/bin/env bash

function PrintInfo()
{
    # TASK 1:
    #  printf "\e[1;4;92mINFO\e[24m:\e[22m $@\e[0m\n"
    #
    # TASK 2:
    #  local string label; label='INFO'
    #  printf "\e[1;4;92m${label}\e[24m:\e[22m $1\n"
    #  shift
    #  for string; do
    #      printf "${label//?/ }  $1\n"
    #      shift
    #  done
    #  printf '\e[0m'
    #
    # TASK 3:
    Logger 'INFO' "$@"
}

function PrintError()
{
    # TASK 1:
    #  printf "\e[1;4;91mERROR\e[24m:\e[22m $@\e[0m\n" 1>&2
    #
    # TASK 2:
    #
    #  local string label; label='ERROR'
    #  printf "\e[1;4;91m${label}\e[24m:\e[22m $1\n" 1>&2
    #  shift
    #  for string; do
    #      printf "${label//?/ }  $1\n" 1>&2
    #      shift
    #  done
    #  printf '\e[0m' 1>&2
    #
    # TASK 3:
    Logger 'ERROR' "$@"
}

# TASK 3,4,5:
function Logger()
{
    local label color
    label="$1"; shift
    IsLevelOn "${label}" || return 0
    case "${label}" in
        ERROR|FATAL )
            color='\e[91m'
            exec 3>&1 1>&2 ;;
        INTERNAL )
            color='\e[38;5;202m' ;;
        INFO )
            color='\e[92m' ;;
        WARNING )
            color='\e[93m' ;;
        DEBUG )
            color='\e[96m' ;;
        TRACE )
            color='\e[38;5;247m' ;;
        * )
            printf "\e[1;4;38;5;202mINTERNAL\e[24m:\e[22m Logger called without unknown label '${label}'!\n\n\e[0m"; exit 1 ;;
    esac
    if [[ $# -eq 0 ]]; then
        printf "\e[1;4;38;5;202mINTERNAL\e[24m:\e[22m Logger called without arguments!\n\n\e[0m"; exit 1
    fi
    printf "\e[1;4m${color}${label}\e[24m:\e[22m ${1//%/%%}\n"
    shift
    for string; do
        printf "${label//?/ }  ${1//%/%%}\n"
        shift
    done
    if [[ ${label} = 'INTERNAL' ]]; then
        printf "${label//?/ }  Please, contact developers.\n"
    fi
    printf '\n\e[0m'
    if [[ ${label} =~ ^(ERROR|FATAL)$ ]]; then
        exec 1>&3-
    fi
    if [[ ${label} = 'FATAL' ]]; then
        exit 1 # <- Here for FATAL you could pass the error code as second argument!
    fi
}

# TASK 4:
function PrintWarning()
{
    Logger 'WARNING' "$@"
}

# TASK 5:
function PrintFatal()
{
    Logger 'FATAL' "$@"
}

function PrintInternal()
{
    Logger 'INTERNAL' "$@"
}

function PrintDebug()
{
    Logger 'DEBUG' "$@"
}

function PrintTrace()
{
    Logger 'TRACE' "$@"
}

function IsLevelOn()
{
    local label
    label="$1"
    # FATAL and INTERNAL always on
    if [[ ${label} =~ ^(FATAL|INTERNAL)$ ]]; then
        return 0
    fi
    # VERBOSE environment variable defines how verbose the output shouold be:
    #  - unset or empty -> till INFO (no DEBUG TRACE)
    #  - numeric -> till that level (1=ERROR, 2=WARNING, ...)
    #  - string  -> till that level
    local loggerLevels loggerLevelsOn level index
    loggerLevels=( [1]='ERROR' [2]='WARNING' [3]='INFO' [4]='DEBUG' [5]='TRACE' )
    loggerLevelsOn=()
    if [[ ${VERBOSE} =~ ^[0-9]+$ ]]; then
        loggerLevelsOn=( "${loggerLevels[@]:1:VERBOSE}" )
    elif [[ ${VERBOSE} =~ ^(ERROR|WARNING|INFO|DEBUG|TRACE)$ ]]; then
        for level in "${loggerLevels[@]}"; do
            loggerLevelsOn+=( "${level}" )
            if [[ ${VERBOSE} = "${level}" ]]; then
                break
            fi
        done
    else
        loggerLevelsOn=( 'FATAL' 'ERROR' 'WARNING' 'INFO' )
    fi
    for  level in "${loggerLevelsOn[@]}"; do
        if [[ ${label} = "${level}" ]]; then
            return 0
        fi
    done
    return 1
}

#-----------------------------------------------

# TASK 1:
#  PrintInfo 'An informational message'
#  PrintError 'An error message'

# TASK 2,3:
#  PrintError 'An error message' 'which spans two lines' 'or three'
#  PrintInfo 'A multiple line' 'info message'

# TASK 4:
#  PrintWarning 'A warning message' 'quite long'

# TASK 5:
#  PrintInternal 'Test an internal message'
#  PrintDebug 'A debug message'
#  PrintTrace 'A trace message' 'for example entering or' 'exiting any function'
#  PrintFatal 'A fatal error occurred! Exiting...'
#  echo 'This is not printed!'
