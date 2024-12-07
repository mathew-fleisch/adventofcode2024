# adventofcode2024

https://adventofcode.com/2024


## Day 01

For [today's challenge](01), I split the two columns of data into two newline separated strings, and used the sort, uniq and grep tools to calculate frequency and difference between each column.

```bash
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

skipped for now...

## Day 03

For [today's challenge](03), I used regular expression matching in sed and grep to make the data easy to loop over.

```bash
~/src/adventofcode2024 $ ./03/answer1.sh             
Answer: 161

~/src/adventofcode2024 $ ./03/answer2.sh 
Answer: 48
```

## Day 04

For [today's challenge](04), I split the data into a grid using an associative array where the key includes the x,y coordinates to each character. A nested for loop iterates around a potential match in the 8 possible neighbors, and tests if the word is XMAS. The second challenge didn't require the nested loop as there were only four possible matches.


```bash

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