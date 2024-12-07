#!/usr/bin/env bash

aoc_input_file=${1:-04/example1.txt}
cat $aoc_input_file && echo 
declare -A matrix
width=0
height=0
x=0
y=0
while read -r line; do
	while IFS='' read -r -d '' -n 1 char; do
			matrix["$y.$x"]=$char
			((x++))
		if [[ $y -eq 0 ]]; then
			((width++))
		fi
	done < <(printf %s "$line")
	((y++))
	((height++))
	x=0
done < "$aoc_input_file"
#echo "width: $width   height: $height"
display_matrix() {
	for key in "${!matrix[@]}"; do
		printf "%s=%s\n" "$key" "${matrix[$key]}"
	done | sort -V
}
#echo "matrix[y.x]:" && display_matrix
display_grid() {
	local grid
	grid=""
	for ((j=0; j<height; j++)); do
		grid=""
		for ((i=0; i<width; i++)); do
			grid="${grid}${matrix[$j.$i]}"
		done
		echo "$grid"
	done
}
# echo "Grid:" && echo "$(display_grid)"

check_xmas() {
	local y
	local x
	local total
	y=$1
	x=$2
	total=0
	if [[ ${matrix[$y.$x]} == "A" ]]; then
		# echo "checking: matrix[$y.$x] = ${matrix[$y.$x]}"
		# echo "could be..."
		word1="${matrix[$((y-1)).$((x-1))]}${matrix[$y.$x]}${matrix[$((y+1)).$((x+1))]}"
		word2="${matrix[$((y+1)).$((x+1))]}${matrix[$y.$x]}${matrix[$((y-1)).$((x-1))]}"
		word3="${matrix[$((y-1)).$((x+1))]}${matrix[$y.$x]}${matrix[$((y+1)).$((x-1))]}"
		word4="${matrix[$((y+1)).$((x-1))]}${matrix[$y.$x]}${matrix[$((y-1)).$((x+1))]}"
		# echo "$word1"
		# echo "$word2"
		# echo "$word3"
		# echo "$word4"
		if [[ "$word1" == "MAS" ]]; then
			((total++))
		fi
		if [[ "$word2" == "MAS" ]]; then
			((total++))
		fi
		if [[ "$word3" == "MAS" ]]; then
			((total++))
		fi
		if [[ "$word4" == "MAS" ]]; then
			((total++))
		fi
	fi
	# echo "sub-total: $total"
	if [ $total -gt 1 ]; then
		echo 1
	else
		echo 0
	fi
}
total=0
for ((a=0; a<height; a++)); do
	for ((b=0; b<width; b++)); do
		this_total="$(check_xmas $a $b)"
		# echo "$this_total"
		total=$((total+this_total))
	done
done
echo "Total: $total"
