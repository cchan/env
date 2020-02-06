#!/bin/bash
[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"
apt-get purge nvidia*
add-apt-repository ppa:graphics-drivers/ppa
apt update
apt install nvidia-driver-440
echo "Rebooting now. Try lsmod | grep nvidia to check after the reboot."
reboot
#service gdm3 stop
#echo 0 > /sys/class/vtconsole/vtcon1/bind
#rmmod nouveau
#modprobe nvidia
#service gdm3 start
