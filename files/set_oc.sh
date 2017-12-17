#!/bin/bash
X :0 &
sleep 5
export DISPLAY=:0
sleep 3
/home/miner/nvoc.sh
exit 0