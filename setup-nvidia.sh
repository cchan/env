#!/bin/bash
#wget https://repo.anaconda.com/archive/Anaconda3-2019.10-Linux-x86_64.sh
#bash Anaconda3-2019.10-Linux-x86_64.sh
#conda install pytorch torchvision cudatoolkit=10.1 -c pytorch

echo Just use https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html
echo Also make sure to get CuDNN.

#[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"
#apt-get purge nvidia*
#add-apt-repository ppa:graphics-drivers/ppa
#apt update
#apt install nvidia-driver-440
#echo "Rebooting now. Try lsmod | grep nvidia to check after the reboot."
#reboot

#service gdm3 stop
#echo 0 > /sys/class/vtconsole/vtcon1/bind
#rmmod nouveau
#modprobe nvidia
#service gdm3 start