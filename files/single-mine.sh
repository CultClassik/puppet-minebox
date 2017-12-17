#!/bin/bash
# Chris Diehl <cultclassik@gmail.com>

MY_ADDRESS='0x96ae82e89ff22b3eff481e2499948c562354cb23'
MY_RIG=`uname -n`
CUDA_PH='4'
ETH_POOl1='us1.ethermine.org:4444'
ETH_POOL2='us2.ethermine.org:4444'
ETH_API_PORT='3000'

export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100


gpu_count=0
IFS=')'
gpus=($(nvidia-smi -L))
for x in "${gpus[@]}"; 
do 
    ~/ethminer/bin/ethminer --farm-recheck 200 -U -S us1.ethermine.org:4444 -FS us2.ethermine.org:4444 -O "$MY_ADDRESS.$MY_RIG" \
--cuda-parallel-hash $CUDA_PH --api-port $ETH_API_PORT --cuda-devices 

done
