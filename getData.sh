#!/bin/bash

# blockHeight=501300

blockHeight=501500
qtyCores=36
loopCores=$qtyCores-1

inc=500
totalInc=500*$qtyCores
maxHeightAt500=$(((498000 / ($qtyCores * 500)) * $qtyCores * 500))
maxHeightAt150=$(((498000 / ($qtyCores * 150)) * $qtyCores * 150))

for n in {0..35}; do   # start 36 fetch loops
    i=$((0+inc*n))
    j=$((499+inc*n))
    datasetNum=$n
    count=0
    while [ $i -lt $blockHeight ]; do

	datasetNum=$((n+qtyCores*count))
	touch "./data/data$datasetNum.csv"
	filesize="$(wc -c <"./data/data$datasetNum.csv")"
	
	while [ $filesize -lt 100 ]; do
	    curl -s -o "./data/data$datasetNum.csv" "https://api.blockchair.com/bitcoin/outputs?q=is_spent(0),block_id($i..$j)&fields=recipient,value&export=csv"
	    filesize="$(wc -c <"./data/data$datasetNum.csv")"

	    # echo "curl -s -o './data/data$datasetNum.csv' 'https://api.blockchair.com/bitcoin/outputs?q=is_spent(0),block_id($i..$j)&fields=recipient,value&export=csv'" >> commands.txt
	    # echo "wget --no-cache -O './data/data$datasetNum.csv' 'https://api.blockchair.com/bitcoin/outputs?q=is_spent\(0\),block_id\($i..$j\)&fields=recipient,value&export=csv'" >> commands.txt
	    if [ $filesize -gt 100 ]; then
		i=$((i+totalInc))
		j=$((j+totalInc))

		if [ $i -ge $maxHeightAt500 -a $i -eq 500 ]; then
		    totalInc=150*qtyCores
		    i=$((i-350*$n))
		    j=$((j-350*($n+1)))
		fi
		
		if [ $i -ge $maxHeightAt150 -a $i -eq 150 ]; then
		    totalInc=125*qtyCores
		    i=$((i-25*$n))
		    j=$((j-25*($n+1)))
		fi
	    else
		sleep $(( (RANDOM % 10) + 10))s
	    fi
	done
	count=$((count+1))
    done &
done
