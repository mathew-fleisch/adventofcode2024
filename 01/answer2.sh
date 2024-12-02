#!/usr/bin/env bash

aoc_input_file=${1:-01/example.txt}

col1=$(cat $aoc_input_file | awk '{print $1}' | sort)
col2=$(cat $aoc_input_file | awk '{print $2}' | sort)
col2_freq=$(echo "$col2" | uniq -c)
rows=$(echo "$col1" | wc -l | awk '{print $1}')
frequency=0

for (( row = 1; row <= rows; row++ )); do
    rc1=$(echo "$col1" | head -n $row | tail -1)
    rc2=$(echo "$col2" | head -n $row | tail -1)
    freq=$(echo "$col2_freq" | grep -E " $rc1$")
    if [ -z "$freq" ]; then
        freq=0;
    else
        freq1=$(echo "$freq" | awk '{print $1}')
        freq2=$(echo "$freq" | awk '{print $2}')
        freq=$((freq1*freq2))
    fi
    echo "row[$row]: $rc1:$rc2 => $freq"
    frequency=$((frequency+freq))
done

echo "Total Frequency: $frequency"
