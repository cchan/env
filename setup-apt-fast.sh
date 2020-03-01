#!/bin/sh
set -e

sudo apt -y install software-properties-common
sudo apt -y install axel
sudo add-apt-repository ppa:apt-fast/stable
sudo apt update
sudo apt -y install apt-fast
