#!/bin/bash

blockHeight=501300
qtyCores=8
loopCores=$qtyCores-1

for set in {0..7}
do
    nohup Rscript getData.R $set $blockHeight $qtyCores &
done
