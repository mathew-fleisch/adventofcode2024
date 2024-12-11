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
		visited["$y.$x.^"]=0
		obs["$y.$x"]=0
		if [[ "$char" == "^" ]]; then
			startx=$x
			starty=$y
			visited["$y.$x.^"]=1
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

# display_visited_grid() {
# 	local grid
# 	grid=""
# 	for ((j=0; j<height; j++)); do
# 		grid=""
# 		for ((i=0; i<width; i++)); do
# 			if [[ ${obs["$j.$i"]} -eq 1 ]]; then
# 				grid="${grid}0"
# 			else
# 				grid="${grid}${visited_so_far[$j.$i]}"
# 			fi
# 		done
# 		echo "$grid"
# 	done
# }
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
	local this_direction
	local orig_direction
	local position
	this_direction=$1
	orig_direction=$this_direction
	this_y=$2
	this_x=$3
	obs_y=$4
	obs_x=$5
	position="$this_y.$this_x"
	local next_y
	local next_x
	local turn
	turn="."
	next_y=0
	next_x=0
	declare -A visited_so_far
	if [[ $obs_y -eq $starty ]] && [[ $obs_x -eq $startx ]] || [[ "${matrix[$obs_y.$obs_x]}" == "#" ]] || [[ ${obs["$obs_y.$obs_x"]} -eq 1 ]]; then
		return
	fi
	for key in "${!visited[@]}"; do
		visited_so_far[$key]=${visited[$key]}
	done
	matrix["$obs_y.$obs_x"]="#"

	while [[ $this_y -lt $height ]] && [[ $this_x -lt $width ]] && [[ $this_y -ge 0 ]] && [[ $this_x -ge 0 ]]; do

		if [[ $iteration -gt $((width*height)) ]]; then
			obs["$obs_y.$obs_x"]=1
			matrix["$obs_y.$obs_x"]=$orig_direction
			return
		fi
		loop=""
		IFS="." read -r this_y this_x <<< "$position"
		next_y=$this_y
		next_x=$this_x
		case $this_direction in
			"^")
			# echo "up"
			next_y=$((this_y-1))
			turn=">"
			;;
			">")
			# echo "right"
			next_x=$((this_x+1))
			turn="v"
			;;
			"v")
			# echo "down"
			next_y=$((this_y+1))
			turn="<"
			;;
			"<")
			# echo "left"
			next_x=$((this_x-1))
			turn="^"
			;;
		esac

		if [[ ${visited_so_far["$next_y.$next_x.$this_direction"]} -eq 1 ]]; then
			# echo "Loop1 detected"

			# grid="$(display_visited_grid)"
			# clear
			# echo "$grid"
			# echo "$(convertsecs $diff)[$iteration]: $this_direction $y.$x => $next_y.$next_x"
			obs["$obs_y.$obs_x"]=1
			# echo 1
			matrix["$obs_y.$obs_x"]=$orig_direction
			return
		fi


		if [[ "${matrix[$next_y.$next_x]}" == "#" ]]; then
			this_direction=$turn
			continue
		fi
		
		visited_so_far["$this_y.$this_x.$this_direction"]=1
		position="$next_y.$next_x"
		# sleep 1
		((iteration++))
	done
	# echo 0
	matrix["$obs_y.$obs_x"]=$orig_direction
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

y=$starty
x=$startx

while [[ $y -lt $height ]] && [[ $x -lt $width ]] && [[ $y -ge 0 ]] && [[ $x -ge 0 ]]; do
#while [[ $nexty -lt $height ]] && [[ $nextx -lt $width ]] && [[ $nexty -ge 0 ]] && [[ $nextx -ge 0 ]]; do
	now=$(date +%s)
	diff=$((now-started))
	if [[ $((iteration%100)) -eq 0 ]]; then
		grid="$(display_grid)"
		clear
		echo "$grid"
		echo "$(convertsecs $diff)[$iteration]: $direction $y.$x => $nexty.$nextx"
		sleep .05
	fi
	loop=""
	IFS="." read -r y x <<< "$position"
	nexty=$y
	nextx=$x
	case $direction in
		"^") 
		# echo "up"
		nexty=$((y-1))
		turn=">"
		check_loop $turn $y $x $nexty $nextx
		;;
		">")
		# echo "right"
		nextx=$((x+1))
		turn="v"
		check_loop $turn $y $x $nexty $nextx
		;;
		"v")
		# echo "down"
		nexty=$((y+1))
		turn="<"
		check_loop $turn $y $x $nexty $nextx
		;;
		"<")
		# echo "left"
		nextx=$((x-1))
		turn="^"
		check_loop $turn $y $x $nexty $nextx
		;;
	esac
	if [[ "${matrix[$nexty.$nextx]}" == "#" ]]; then
		direction=$turn
		matrix["$y.$x"]=$direction
		visited["$y.$x.$direction"]=1
		continue
	fi
	
	matrix["$nexty.$nextx"]=$direction
	visited["$y.$x.$direction"]=1
	
	# echo "grid[$height.$width]: cur[$y.$x] -> next[$nexty.$nextx]"
	position="$nexty.$nextx"
	# sleep 1
	((iteration++))
done


now=$(date +%s)
diff=$((now-started))
grid="$(display_grid)"
clear
echo "$grid"
echo "$(convertsecs $diff)[$iteration]: $direction $y.$x => $nexty.$nextx"
for key in "${!obs[@]}"; do
	# printf "%s=%s\n" "$key" "${obs[$key]}"
	this="${obs[$key]}"
	total=$((total+this))
done
now=$(date +%s)
diff=$((now-started))
grid="$(display_grid)"
clear
echo "Total Obstacles: $total"
echo "$grid"
echo "$(convertsecs $diff)[$iteration]: $direction $y.$x => $nexty.$nextx"
echo "Total Obstacles: $total"
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
