#!/usr/bin/env bash

aoc_input_file=${1:-01/example.txt}

col1=$(cat $aoc_input_file | awk '{print $1}' | sort)
col2=$(cat $aoc_input_file | awk '{print $2}' | sort)

rows=$(echo "$col1" | wc -l | awk '{print $1}')
difference=0

for (( row = 1; row <= rows; row++ )); do
    rc1=$(echo "$col1" | head -n $row | tail -1)
    rc2=$(echo "$col2" | head -n $row | tail -1)
    if [ $rc1 -gt $rc2 ]; then
        local_diff=$((rc1-rc2))
    else
        local_diff=$((rc2-rc1))
    fi
    difference=$((difference+local_diff))
    echo "row[$row]: $rc1:$rc2 => $local_diff"
done

echo "Total Difference: $difference"
