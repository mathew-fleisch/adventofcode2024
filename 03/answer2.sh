#!/usr/bin/env bash

aoc_input_file=${1:-03/example2.txt}

input_string=$(cat "$aoc_input_file" \
    | tr -d '\n' \
    | sed -e 's/do(/\ndo(/g' \
    | sed -e "s/don't(.*//g" \
    | sed -e 's/mul/\nmul/g' \
    | grep -E "mul\([0-9]*,[0-9]*\)" \
    | sed -e 's/.*mul(\([0-9]*\),\([0-9]*\)).*/\1,\2/g')
# echo "$input_string"
answer=0
IFS=',' && while read -r lhs rhs; do
    this=$((lhs*rhs))
    # echo "$lhs * $rhs = $this"
    answer=$((answer+this))
done <<< "$input_string"
echo "Answer: $answer"