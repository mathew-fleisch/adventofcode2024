# adventofcode2024

https://adventofcode.com/2024


## Day 01

For [today's challenge](01), I split the two columns of data into two newline separated strings, and used the sort, uniq and grep tools to calculate frequency and difference between each column.

```text
~/src/adventofcode2024 $ ./01/answer1.sh          
row[1]: 1:3 => 2
row[2]: 2:3 => 1
row[3]: 3:3 => 0
row[4]: 3:4 => 1
row[5]: 3:5 => 2
row[6]: 4:9 => 5
Total Difference: 11

~/src/adventofcode2024 $ ./01/answer2.sh 
row[1]: 1:3 => 0
row[2]: 2:3 => 0
row[3]: 3:3 => 9
row[4]: 3:4 => 9
row[5]: 3:5 => 9
row[6]: 4:9 => 4
Total Frequency: 31
```

## Day 02

For [today's challenge](02), I first iterated line by line to calculate each level. I then pulled that logic into a function that took an index and a space separated string of integers. I then split each row up into an array and passed each failed row to test without one element in the array.

```text
~/src/adventofcode2024 $ 02/answer1.sh
Levels Safe: 2

~/src/adventofcode2024 $ 02/answer2.sh
Levels Safe: 4
```

## Day 03

For [today's challenge](03), I used regular expression matching in sed and grep to make the data easy to loop over.

```text
~/src/adventofcode2024 $ ./03/answer1.sh             
Answer: 161

~/src/adventofcode2024 $ ./03/answer2.sh 
Answer: 48
```

## Day 04

For [today's challenge](04), I split the data into a grid using an associative array where the key includes the x,y coordinates to each character. A nested for loop iterates around a potential match in the 8 possible neighbors, and tests if the word is XMAS. The second challenge didn't require the nested loop as there were only four possible matches.


```text

Total: 18
~/src/adventofcode2024 $ ./04/answer1.sh
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX

Total: 18


~/src/adventofcode2024 $ ./04/answer2.sh
MMMSXXMASM
MSAMXMSMSA ~/src/adventofcode2024
 % ./04/answer1.sh
MMMSXXMASM
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX

Total: 9
```

## Day 05

skipped...

## Day 06

For [today's challenge](06), I copied the code I made for day04 to load in a file character, by character into an associative array with the x,y coordinates as the key.

***Part1***

In the first part, the character must navigate a 2d grid with obstacles represented as `#` and must always move in the same direction until an obstacle is encountered; turn right, and continue until off the map. Another array is saved with the same keys as the map, but the value of each element is a 1 if the character has been to that space, and a 0 if not. A sum of all of those positions returns the answer.

```text
~/src/adventofcode2024 $ ./06/answer1.sh             
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...

0000000000
0000111110
0000100010
0000100010
0011111010
0010101010
0011111110
0111111100
0111111100
0000000100
total: 41
```

***Part2***

In the second part, the goal is to find all of the places in the map where adding an additional obstacle would get the character stuck in a loop. Rather than keeping track of if the character has been to a position or not, a new variable keeps track of the previous direction. Before taking each step, the spot is evaluated as an obstacle. If the potential obstacle makes the character encounter a previously visited space, in the same direction, it would get stuck in a loop, and that spot would return a 1. Summing all of those spaces, should give the correct answer, but it doesn't. There is still something wrong.

```
~/src/adventofcode2024 $ ./06/answer2.sh             
....#.....
....>>>>v#
....^...v.
..#.^...v.
..>>>>v#v.
..^.^.v.v.
.#^0<<v<<.
.>>>>>00#.
#0<0<<<v..
......#0..
00:00:01[44]: v 8.7 => 9.7
total: 6
Completed in: 00:00:01
```

## Day 07

For [today's challenge](07), I created a function that would convert decimal numbers to any base and used those characters to brute force each possibility. I also incorporated a technique for threading I learned from [Dave Eddy](https://ysap.sh) in [answer2.1.sh](07/answer2.1.sh) to speed up the processing of part2.

```text
~/src/adventofcode $ ./07/answer1.sh  
0[MATCH]-> 190: 10 19
1[MATCH]-> 3267: 81 40 27
8[MATCH]-> 292: 11 6 16 20

Total: 3749
~/src/adventofcode $ ./07/answer2.sh   
0[MATCH]-> 190: 10 19
1[MATCH]-> 3267: 81 40 27
3[MATCH]-> 156: 15 6
4[MATCH]-> 7290: 6 8 6 15
6[MATCH]-> 192: 17 8 14
8[MATCH]-> 292: 11 6 16 20
Total: 11387

~/src/adventofcode $ ./07/answer2.1.sh 
0[MATCH]-> 190: 10 19
1[MATCH]-> 3267: 81 40 27
2[NOPE]-> 83: 17 5
3[MATCH]-> 156: 15 6
4[MATCH]-> 7290: 6 8 6 15
5[NOPE]-> 161011: 16 10 13
6[MATCH]-> 192: 17 8 14
7[NOPE]-> 21037: 9 7 18 13
8[MATCH]-> 292: 11 6 16 20
Total: 11387
```