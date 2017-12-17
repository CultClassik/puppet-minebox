#!/bin/bash
# Chris Diehl
# Returns the number of NVidia GPUs found on the system.
# Used for Puppet external fact.

gpu_count=0
IFS=')'
gpus=($(nvidia-smi -L))
for x in "${gpus[@]}"; 
do 
    gpu_count=$(( $gpu_count + 1 ));
done

count=$((gpu_count))
echo "{\"gpu-count\":\"${count}\"}"