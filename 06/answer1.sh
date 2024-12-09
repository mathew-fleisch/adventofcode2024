#!/usr/bin/env bash

aoc_input_file=${1:-06/example.txt}
cat $aoc_input_file && echo 
declare -A matrix
declare -A visited
width=0
height=0
x=0
y=0
startx=0
starty=0
while read -r line; do
	while IFS='' read -r -d '' -n 1 char; do
		matrix["$y.$x"]=$char
		if [[ "$char" == "^" ]]; then
			visited["$y.$x"]=1
			startx=$x
			starty=$y
		else
			visited["$y.$x"]=0
		fi
		((x++))
		if [[ $y -eq 0 ]]; then
			((width++))
		fi
	done < <(printf %s "$line")
	((y++))
	((height++))
	x=0
done < "$aoc_input_file"
# echo "width: $width   height: $height"
display_matrix() {
	for key in "${!matrix[@]}"; do
		printf "%s=%s\n" "$key" "${matrix[$key]}"
	done | sort -V
}
# echo "matrix[y.x]:" && display_matrix
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
# y-1
up="^"
# y+1
down="v"
# x-1
left="<"
# x+1
right=">"

# echo "start: [$starty.$startx] ${matrix[$starty.$startx]}"

iteration=0

direction=$up
position="$starty.$startx"
turn=">"
nexty=0
nextx=0

while [[ $nexty -lt $height ]] && [[ $nextx -lt $width ]] && [[ $nexty -ge 0 ]] && [[ $nextx -ge 0 ]]; do
	# this_grid="$(display_grid)"
	# clear && echo "$iteration:" && echo "$this_grid"
	# echo "$iteration"

	IFS="." read -r y x <<< "$position"
	case $direction in
		"^")
		# echo "up"
		nexty=$((y-1))
		nextx=$x
		turn=">"
		;;
		">")
		# echo "right"
		nexty=$y
		nextx=$((x+1))
		turn="v"
		;;
		"v")
		# echo "down"
		nexty=$((y+1))
		nextx=$x
		turn="<"
		;;
		"<")
		# echo "left"
		nexty=$y
		nextx=$((x-1))
		turn="^"
		;;
	esac

	if [[ "${matrix[$nexty.$nextx]}" == "#" ]]; then
		matrix["$y.$x"]=$turn
		visited["$y.$x"]=1
		direction=$turn
		continue
	fi
	
	matrix["$nexty.$nextx"]=$direction
	matrix["$y.$x"]="."
	visited["$y.$x"]=1
	
	# echo "grid[$height.$width]: cur[$y.$x] -> next[$nexty.$nextx]"
	position="$nexty.$nextx"
	# sleep 1
	((iteration++))
done



total=0
for key in "${!visited[@]}"; do
	# printf "%s=%s\n" "$key" "${visited[$key]}"
	this="${visited[$key]}"
	total=$((total+this))
done

grid=""
for ((j=0; j<height; j++)); do
	grid=""
	for ((i=0; i<width; i++)); do
		grid="${grid}${visited[$j.$i]}"
	done
	echo "$grid"
done

echo "total: $total"