#!/usr/bin/env bash

# A proof of concept about how to use Python inside a Bash script

temperatures=(100 150 200 250 300)
cross_sections=(1.2 1.8 2.9 4.5 6.8)

IFS=','
python3 <<PY
import matplotlib.pyplot as plt

T = [${temperatures[*]}]
sigma = [${cross_sections[*]}]

plt.plot(T, sigma, marker='o')
plt.xlabel("Temperature")
plt.ylabel("Cross section")
plt.savefig("cross_section.pdf")
PY
unset IFS

exit 0

# Instead of using IFS you can use:
joined_T=$(printf '%s,' "${temperatures[@]}")
joined_T=${joined_T%,}

# Or directly inside the here document:
#
#  T = [$(IFS=,; echo "${temperatures[*]}")]
#
