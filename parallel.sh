#!/bin/bash

blockHeight=501300
qtyCores=16
loopCores=$qtyCores-1

for set in {0..15}
do
    nohup Rscript getData.R $set $blockHeight $qtyCores &
done
