#!/usr/bin/env bash

aoc_input_file=${1:-02/example.txt}
safe=0
index=0
declare -A levels

check_level() {
    local level
    index=$1
    level="$2"
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
    #return $level_safe
    levels[$index]=$level_safe
}


# echo "-${index}-------------"
while read this_level; do
    level_safe=0
    check_level $index "$this_level"
    if [[ "${levels[$index]}" != 1 ]]; then
	read -a this <<< "$this_level"
	read -a check_this <<< "$this_level"
	# echo "${check_this[@]}"
	for ind in "${!check_this[@]}"; do
		check=""
		# echo "Checking without: ${check_this[$ind]}"
		for inner_ind in "${!this[@]}"; do
			if [ $ind -ne $inner_ind ]; then
				check="$check ${this[$inner_ind]}"
			fi
		done
		check_level $index "$check"
		if [[ "${levels[$index]}" == 1 ]]; then
			# echo "----> SAFE <-----"
			break
		fi
	done
    fi
    ((index++))
    # echo
    # echo "-${index}-------------"
    # echo
done < $aoc_input_file
for key in "${!levels[@]}"; do
	safe=$((safe+levels[$key]))
done
echo "Levels Safe: $safe"
