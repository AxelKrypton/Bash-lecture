#!/usr/bin/env bash

nn_finder='./Next-neighbour-clean.bash'

if [[ ! -x "${nn_finder}" ]]; then
    echo "ERROR: File ${nn_finder} not found."
    exit 1
fi

readonly Nx=5 Ny=8

next_neighbours=()

for (( i=0; i<Nx; i++ )); do
    for (( j=0; j<Ny; j++ )); do
        (( s = i + j*Nx ))
        next_neighbours[s]="$(./Next-neighbour-clean.bash ${Nx}x${Ny} ${i} ${j})"
    done
done

next_neighbours=( "${next_neighbours[@]%?}" )

for (( s=0; s<Nx*Ny; s++ )); do
    echo "next_neighbours[${s}]=(${next_neighbours[s]})"
done
