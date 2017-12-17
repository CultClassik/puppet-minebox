#!/bin/bash
# Chris Diehl

mypath="/home/miner/oc-scripts"

export DISPLAY=:0

nvidia-smi -pm ENABLED
nvidia-smi -pl 100

for i in `ls ${mypath}/*.sh`
do
 $i
done
