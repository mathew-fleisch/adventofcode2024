#!/usr/bin/env bash

aoc_input_file=${1:-02/example.txt}
safe=0

while read level; do
    # echo "level: $level"
    last=0
    level_safe=1
    direction=0
    for col in $level; do
        if [ $last -eq 0 ]; then
            last=$col
            continue
        fi
        # check ascending/descending
        tdiff=0
        if [ $last -gt $col ]; then
            # desc
            tdiff=$((last-col))
            if [ $direction -eq 0 ]; then
                direction=-1
            elif [ $direction -eq 1 ]; then
                level_safe=0
                # echo "NOT SAFE!"
                break
            fi
        else
            #asc
            tdiff=$((col-last))
            if [ $direction -eq 0 ]; then
                direction=1
            elif [ $direction -eq -1 ]; then
                level_safe=0
                # echo "NOT SAFE!"
                break
            fi
        fi
        # echo "$last diff $col => $tdiff"
        if [ $tdiff -gt 3 ] || [ $tdiff -eq 0 ]; then
            level_safe=0
            # echo "NOT SAFE!"
            break
        fi
        last=$col
    done
    safe=$((safe+level_safe))
    # echo "--------------"
done < $aoc_input_file

echo "Levels Safe: $safe"