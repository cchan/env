#!/bin/bash
sudo add-apt-repository ppa:graphics-drivers/ppa
sudo apt update
sudo apt install nvidia-driver-440
sudo service gdm3 stop
sudo sh -c "echo 0 > /sys/class/vtconsole/vtcon1/bind"
sudo rmmod nouveau
sudo modprobe nvidia
sudo service gdm3 start
