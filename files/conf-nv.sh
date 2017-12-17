#!/bin/bash
# Chris Diehl
# GPU ethminer setup for NVidia GPU systems - use root or sudo
# Run this script any time GPUs are moved, removed or added

# Check that user is running as sudo.
if (( $EUID != 0 )); then
    echo "Please run as root"
    exit
fi

nvidia-xconfig -a \
  --enable-all-gpus \
  --cool-bits=28 \
  --use-display-device="DFP-0" \
  --connected-monitor="DFP-0" \
  --separate-x-screens \
  --allow-empty-initial-configuration &&\
sed -i '/BusID.*/a \ \ \ \ Option         "Interactive" "False"' /etc/X11/xorg.conf

update-rc.d xdm defaults

#echo "Check for errors and run this when finished:"
#echo 'sync && reboot'

# For use with Puppet
sync
