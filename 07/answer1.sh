#!/usr/bin/env bash
aoc_input_file=${1:-07/example.txt}
#cat $aoc_input_file && echo 
operators=('+' '*')
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
total=0
line_num=0
base=${#operators[@]}

while read -r line; do
	if [ -n "$line" ]; then
		# echo "$line"
		read -a nums <<< "$line"
		target=${nums[0]//:/}
		nums=("${nums[@]:1}")
		len=${#nums[@]}
		row=$((base**(len-1)))
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
				esac
				((space++))
			done
			# echo "this_total: $this_total"
			if [ $this_total -eq $target ]; then
				total=$((total+target))
				echo "$line_num[MATCH]-> $line"
				break
			fi
		done
	fi
	((line_num++))
done < "$aoc_input_file"
echo "Total: $total"