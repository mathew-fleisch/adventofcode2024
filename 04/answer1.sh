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
	#echo "checking: matrix[$y.$x] = ${matrix[$y.$x]}"
	if [[ ${matrix[$y.$x]} == "X" ]]; then
		#echo "could be..."
		for ((j=-1; j<2; j++)); do
			for ((i=-1; i<2; i++)); do
				word="${matrix[$y.$x]}${matrix[$((y+(1*j))).$((x+(1*i)))]}${matrix[$((y+(2*j))).$((x+(2*i)))]}${matrix[$((y+(3*j))).$((x+(3*i)))]}"
				#echo "\${matrix[$y.$x]}\${matrix[$((y+(1*j))).$((x+(1*i)))]}\${matrix[$((y+(2*j))).$((x+(2*i)))]}\${matrix[$((y+(3*j))).$((x+(3*i)))]}"
				if [[ -n "$word" ]]; then
					#echo "$word"
					if [[ "$word" == "XMAS" ]]; then
						#echo "!!!"
						((total++))
					fi
				fi
			done
		done
	fi
	echo $total
}
total=0
for ((a=0; a<height; a++)); do
	for ((b=0; b<width; b++)); do
		this_total=$(check_xmas $a $b)
		#echo "$this_total"
		total=$((total+this_total))
	done
done
echo "Total: $total"
