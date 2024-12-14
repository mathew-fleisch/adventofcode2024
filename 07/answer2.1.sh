#!/usr/bin/env bash
aoc_input_file=${1:-07/example.txt}
CONCURRENCY=${2:-1}
#cat $aoc_input_file && echo 
# operators=('+' '*')
operators=('+' '*' '||')
declare -A numbers

decimal_to_base() {
    local num=$1
    local base=${2:-2}
	local pad=${3:-2}
    local digits="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    
    # Check if base is between 2 and 36
    if (( base < 2 || base > 36 )); then
        echo "Base must be between 2 and 36."
        return 1
    fi
    
    # Handle zero case
    if (( num == 0 )); then
		printf "%0"$pad"d" "$result"
        return
    fi
    
    # Initialize result
    local result=""
    
    # Convert the number
    while (( num > 0 )); do
        local remainder=$(( num % base ))
        result="${digits:remainder:1}$result"
        num=$(( num / base ))
    done
    
    printf "%0"$pad"d" "$result"
}

# test binary thing
# width=3
# base=2
# target=$((base**width))
# for (( col=0; col<target; col++ )); do
# 	echo "$col $(decimal_to_base $col $base $width)"
# done
# 0 000
# 1 001
# 2 010
# 3 011
# 4 100
# 5 101
# 6 110
# 7 111
line_num=0
base=${#operators[@]}

# if [ -d "07/data" ]; then
# 	rm -rf 07/data
# fi
# mkdir -p 07/data

process_line() {
	local line
	local line_num
	line_num=$1
	line="$2"

	read -a nums <<< "$line"
	target=${nums[0]//:/}
	nums=("${nums[@]:1}")
	len=${#nums[@]}
	row=$((base**(len-1)))
	if [ -f 07/data/$line_num ]; then
		if [ $(cat 07/data/$line_num) -ne 0 ]; then
			return
		fi
	fi
	# echo "target: $target"
	# echo "  nums: ${nums[@]}"
	# echo "   len: $len"
	# echo "   row: $row"
	
	for (( i=0; i<row; i++ )); do
		this=$(decimal_to_base $i $base $((len-1)))
		this_total=0
		space=0
		for num in ${nums[@]}; do
			if [ $this_total -eq 0 ]; then
				this_total=$num
				continue
			fi
			char="${this:$space:1}"
			case $char in
				"0") 
					# echo "this_total=$this_total+$num"
					this_total=$((this_total+num))
					;;
				"1")
					# echo "this_total=$this_total*$num"
					this_total=$((this_total*num))
				;;
				"2")
					this_total="${this_total}${num}"
				;;
			esac
			((space++))
		done
		# echo "this_total: $this_total"
		if [ $this_total -eq $target ]; then
			# total=$((total+target))
			echo $target > 07/data/$line_num
			echo "$line_num[MATCH]-> $line"
			return
		fi
	done
	echo "$line_num[NOPE]-> $line"
	echo "0" > 07/data/$line_num
}



while read -r line; do
	if [ -n "$line" ]; then
		# echo "$line"
		process_line $line_num "$line" &
		pids[$!]='true'

		len=${#pids[@]}
		if ((len >= CONCURRENCY)); then
			# wait for 1 of the CONCURRENCY outstanding tasks to finish
			wait -n -p id "${!pids[@]}"
			code=$?
			unset pids[$id]

			# `code` is the exit code of the function that was spawned
			# `id` is the pid of the function that exited
			# echo "process $id exited $code"
		fi
		((line_num++))
	fi
done < "$aoc_input_file"

while ((${#pids[@]} > 0)); do
    wait -n -p id "${!pids[@]}"
    code=$?
    unset pids[$id]
    # echo "process $id exited $code"
done

total=$(awk '{n += $1}; END{print n}' <<< "$(cat 07/data/*)")
echo "Total: $total"