#!/usr/bin/env bash

#=======================================================================#
# Copyright (c) 2026  Alessandro Sciarra <sciarra@itp.uni-frankfurt.de> #
#                                                                       #
# This is a quick implementation of the Conway's Game of Life according #
# to https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life rules. It is #
# a nice Bash exercise that came up during an evening discussion. The   #
# main challenge is how to handle a grid in a scripting language that   #
# has no multi-dimensional arrays and how to avoid to always find next  #
# neighbours of a given cell.                                           #
#=======================================================================#

function Main()
{
    Setup_Behaviour_On_Exit
    Define_Global_Variables
    Parse_Command_Line_Options "$@"
    Fill_Random_Grid
    Store_Next_Neighbours
    Run_Game
}

#===================#
# LEVEL 1 functions #
#===================#

function Setup_Behaviour_On_Exit()
{
    trap 'Show_Cursor' EXIT
}

function Define_Global_Variables()
{
    readonly cell='  '
    readonly \
        dead="${cell}" \
        alive=$'\e[102m'"${cell}"$'\e[0m'
    Nx=4
    Ny=3
    delta_t="0.1"
    next_neighbours=()
    grid=()
    generation=1 alive_counter=0 dead_counter=0
}

function Parse_Command_Line_Options()
{
    local option
    for option in "$@"; do
        if [[ ${option} =~ ^-(h|-help)$ ]]; then
            set -- '--help'
            break
        fi
    done
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --help)
                printf "\n\e[96m \e[1mSYNOPSIS:\e[22m ${BASH_SOURCE[0]} [-h|--help] [--nx VALUE] [--ny VALUE] [--dt TIME]\e[0m\n"
                printf "\n\e[93m \e[1mNOTE:\e[22m The default and minimum size is Nx=4 and Ny=3 and the default 𝛿t is 0.1s\e[0m\n\n"
                exit 0
                ;;
            --nx)
                if [[ $2 =~ ^[1-9][0-9]?$ ]]; then
                    Nx=$2
                else
                    printf "\n\e[91m ERROR: Value of option '$1' wrongly specified (integer expected).\e[0m\n\n"
                    exit 1
                fi
                shift 2
                ;;
            --ny)
                if [[ $2 =~ ^[1-9][0-9]?$ ]]; then
                    Ny=$2
                else
                    printf "\n\e[91m ERROR: Value of option '$1' wrongly specified (integer expected).\e[0m\n\n"
                    exit 1
                fi
                shift 2
                ;;
            --dt)
                if [[ $2 =~ ^[0-9](\.[0-9]*)?$ ]]; then
                    delta_t=$2
                else
                    printf "\n\e[91m ERROR: Value of option '$1' wrongly specified (expected FP number).\e[0m\n\n"
                    exit 1
                fi
                shift 2
                ;;
            *)
                printf "\n\e[91m ERROR: Option '$1' not recognised.\e[0m\n\n"
                exit 1
                ;;
        esac
    done
    (( Nx < 4 )) && Nx=4
    (( Ny < 3 )) && Ny=3
    readonly Nx Ny
}

function Fill_Random_Grid()
{
    local index
    for (( index=0; index<Nx*Ny; index++ )); do
        if (( RANDOM % 2 == 0 )); then
            grid[index]="${alive}"
            (( alive_counter++ ))
        else
            grid[index]="${dead}"
            (( dead_counter++ ))
        fi
    done
}

function Store_Next_Neighbours()
{
    local index
    for (( index=0; index<Nx*Ny; index++ )); do
        next_neighbours[index]="$(Find_Next_Neighbours_Of_Cell ${index} 2> /dev/null)"
        printf '%d: %s\n' ${index} "${next_neighbours[index]}" > /dev/null # Debug output
    done
    readonly next_neighbours
}

function Run_Game()
{
    clear
    Hide_Cursor
    while true; do
        Print_Grid
        Make_Update
        sleep "${delta_t}"
    done
}

#===================#
# LEVEL 2 functions #
#===================#

function Print_Grid()
{
    local hline y
    printf -v hline '%*s' "$(( ${#cell} * Nx ))" ''
    hline=${hline// /─}
    printf '\e[H' # Move cursor to the home position (row 1, column 1)
    printf '\e[J' # Clear screen to the end of the screen
    printf '╭%s╮\n' "${hline}"
    for ((y=0; y<Ny; ++y)); do
        printf '│'
        printf '%s' "${grid[@]:y*Nx:Nx}"
        printf '│'
        if (( y == Ny/2-1 )); then
            printf '    %10s: %d' 'GENERATION' "${generation}"
        elif (( y == Ny/2 )); then
            printf '    %10s: %d' 'ALIVE' "${alive_counter}"
        elif (( y == Ny/2+1 )); then
            printf '    %10s: %d' 'DEAD' "${dead_counter}"
        fi
        printf '\n'
    done
    printf '╰%s╯\n' "${hline}"
}

function Make_Update()
{
    local index temporary_neighbours nn_index nn_alive
    alive_counter=0 dead_counter=0
    for (( index=0; index<Nx*Ny; index++ )); do
        temporary_neighbours=( ${next_neighbours[index]} )
        nn_alive=0
        for nn_index in "${temporary_neighbours[@]}"; do
            if Is_Alive "${grid[nn_index]}"; then
                (( nn_alive++ ))
            fi
        done
        if Is_Alive "${grid[index]}"; then
            if (( nn_alive < 2 || nn_alive > 3 )); then
                grid[index]="${dead}"
            fi
        else
            if (( nn_alive == 3 )); then
                grid[index]="${alive}"
            fi            
        fi
        Update_Global_Counters "${grid[index]}"
    done
    (( generation++ ))
}

function Hide_Cursor()
{
    printf '\e[?25l'
}

function Show_Cursor()
{
    printf '\e[?25h'
}

function Find_Next_Neighbours_Of_Cell()
{
    local -r \
          i=$(( $1 % Nx )) \
          j=$(( $1 / Nx ))
    local delta_x delta_y ip jp nn
    nn=()   
    for delta_x in -1 0 1; do
        for delta_y in -1 0 1; do
            printf "delta_x = %2s   delta_y = %2s  ->  " "${delta_x}" "${delta_y}"
            if (( delta_x == 0 && delta_y == 0 )); then
                echo "continue (1)"
                continue
            fi
            ip=$(( i + delta_x ))
            jp=$(( j + delta_y ))
            printf "ip = %3s   jp = %3s  ->  " "${ip}" "${jp}"
            if (( ip < 0 || ip >= Nx || jp < 0 || jp >= Ny )); then
                echo "continue (2)"
                continue
            fi
            nn+=( $(Super_Index ${ip} ${jp} ) )
            echo "last nn: ${nn[-1]}"
        done
    done >&2
    printf '%s ' "${nn[@]}"
}

#===================#
# LEVEL 3 functions #
#===================#

function Super_Index()
{
    printf '%d' $(( $1 + $2 * Nx ))
}

function Is_Alive()
{
    [[ "$1" == "${alive}" ]]
}

function Update_Global_Counters()
{
    if Is_Alive "$1"; then
        (( alive_counter++ ))
    else
        (( dead_counter++ ))
    fi
}

#====================================================================================================================================

Main "$@"
