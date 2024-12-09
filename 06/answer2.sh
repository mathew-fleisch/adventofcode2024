#!/usr/bin/env bash
convertsecs() {
  ((h=${1}/3600))
  ((m=(${1}%3600)/60))
  ((s=${1}%60))
  printf "%02d:%02d:%02d\n" $h $m $s
}

started=$(date +%s)

aoc_input_file=${1:-06/example.txt}
cat $aoc_input_file && echo 
declare -A matrix
declare -A visited
declare -A orig
declare -A obs
width=0
height=0
x=0
y=0
startx=0
starty=0
while read -r line; do
	while IFS='' read -r -d '' -n 1 char; do
		matrix["$y.$x"]=$char
		orig["$y.$x"]=$char
		visited["$y.$x"]=$char
		obs["$y.$x"]=0
		if [[ "$char" == "^" ]]; then
			visited["$y.$x"]="^"
			startx=$x
			starty=$y
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
			if [[ ${obs["$j.$i"]} -eq 1 ]]; then
				grid="${grid}0"
			else
				grid="${grid}${matrix[$j.$i]}"
			fi
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

check_loop() {

	local iteration
	iteration=0
	local direction
	local position
	direction=$1
	this_y=$2
	this_x=$3
	obs_y=$4
	obs_x=$5
	position="$this_y.$this_x"
	local y
	local x
	local nexty
	local nextx
	local turn
	turn="."
	nexty=0
	nextx=0
	declare -A visited_so_far
	for key in "${!visited[@]}"; do
		visited_so_far[$key]=${visited[$key]}
	done
	visited_so_far["$obs_y.$obs_x"]="#"

	while [[ $nexty -lt $height ]] && [[ $nextx -lt $width ]] && [[ $nexty -ge 0 ]] && [[ $nextx -ge 0 ]]; do
		# this_grid="$(display_grid)"
		# clear
		# echo "$iteration:" && echo "$this_grid"
		# echo "$iteration"
		if [[ $iteration -gt $((width*height)) ]]; then
			# echo "THIS SHOULD NOT HAPPEN"
			# exit 1
			echo "$obs_y.$obs_x" >> /tmp/what.txt
			echo 1
			return
		fi
		loop=""
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

		if [[ ${visited_so_far["$nexty.$nextx"]} == $direction ]]; then
			# echo "Loop1 detected"
			echo 1
			return
		fi


		if [[ "${visited_so_far[$nexty.$nextx]}" == "#" ]]; then
			direction=$turn
			continue
		fi
		
		visited_so_far["$y.$x"]=$direction
		position="$nexty.$nextx"
		# sleep 1
		((iteration++))
	done
	echo 0
	return
}



# grid=""
# for ((j=0; j<height; j++)); do
# 	grid=""
# 	for ((i=0; i<width; i++)); do
# 		grid="${grid}${visited[$j.$i]}"
# 	done
# 	echo "$grid"
# done


total=0
iteration=0
direction=$up
position="$starty.$startx"

nexty=0
nextx=0

while [[ $nexty -lt $height ]] && [[ $nextx -lt $width ]] && [[ $nexty -ge 0 ]] && [[ $nextx -ge 0 ]]; do
	now=$(date +%s)
	diff=$((now-started))
	# if [[ $((iteration%100)) -eq 0 ]]; then
		grid="$(display_grid)"
		clear
		echo "$grid"
		echo "$(convertsecs $diff)[$iteration]: $direction $y.$x => $nexty.$nextx"
	# fi
	loop=""
	IFS="." read -r y x <<< "$position"
	case $direction in
		"^")
		# echo "up"
		nexty=$((y-1))
		nextx=$x
		turn=">"
		could_loop=$(check_loop $turn $y $x $nexty $nextx)
		;;
		">")
		# echo "right"
		nexty=$y
		nextx=$((x+1))
		turn="v"
		could_loop=$(check_loop $turn $y $x $nexty $nextx)
		;;
		"v")
		# echo "down"
		nexty=$((y+1))
		nextx=$x
		turn="<"
		could_loop=$(check_loop $turn $y $x $nexty $nextx)
		;;
		"<")
		# echo "left"
		nexty=$y
		nextx=$((x-1))
		turn="^"
		could_loop=$(check_loop $turn $y $x $nexty $nextx)
		;;
	esac
	# total=$((total+could_loop))
	if [[ $could_loop -gt 0 ]]; then
		obs["$nexty.$nextx"]=1
	fi

	if [[ "${matrix[$nexty.$nextx]}" == "#" ]]; then
		direction=$turn
		matrix["$y.$x"]=$direction
		visited["$y.$x"]=$direction
		continue
	fi
	
	matrix["$nexty.$nextx"]=$direction
	matrix["$y.$x"]=$direction
	visited["$y.$x"]=$direction
	
	# echo "grid[$height.$width]: cur[$y.$x] -> next[$nexty.$nextx]"
	position="$nexty.$nextx"
	# sleep 1
	((iteration++))
done

for key in "${!obs[@]}"; do
	# printf "%s=%s\n" "$key" "${obs[$key]}"
	this="${obs[$key]}"
	total=$((total+this))
done
echo "total: $total"
# grid=""
# # nums=""
# for ((j=0; j<height; j++)); do
# 	grid=""
# 	# nums=""
# 	for ((i=0; i<width; i++)); do
# 		# grid="${grid}${visited[$j.$i]}"
# 		if [[ ${obs["$j.$i"]} -eq 1 ]]; then
# 			grid="${grid}0"
# 		else
# 			grid="${grid}${visited[$j.$i]}"
# 		fi
# 		# nums="${nums}${obs[$j.$i]}"
# 	done
# 	echo "$grid"
# 	# echo "$grid  $nums"
# done

# echo "total: $total"

now=$(date +%s)
diff=$((now-started))
echo "Completed in: $(convertsecs $diff)"
