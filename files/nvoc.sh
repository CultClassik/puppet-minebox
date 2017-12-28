#!/bin/bash
# Chris Diehl

mypath="/home/miner/oc-scripts"

export DISPLAY=:0

# added 12/28/17, test to ensure system will set OC at boot!
X :0 &

nvidia-smi -pm ENABLED
nvidia-smi -pl 100

for i in `ls ${mypath}/*.sh`
do
 $i
done
