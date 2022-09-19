#!/bin/bash
set -e

# wget https://clive.io/env && bash env <DEVICE_ID>

# For RPi, use https://github.com/cchan/ura_s18 first

if [ -z "$1" ]; then
  echo "Need a unique device number parameter (1-255) for Wireguard."
  exit 1
fi

mkdir -p ~/code
cd ~/code
sudo apt -y install git
git clone https://github.com/cchan/env
cd env

if [ "$(whoami)" == "pi" || "$(whoami)" == "parallella" ]; then
  echo "Skipping apt-fast and conda"
else
  ./setup-apt-fast.sh
  ./setup-conda.sh
fi
./setup-ssh.sh
read -p "Please SSH into the machine, update known_hosts as needed, and add the above pubkey to GitHub. Then press enter to continue."

./setup-git.sh

# It seems impossible to install wireguard on such an old OS, but might be worth revisiting this.
if [ "$(whoami)" != "parallella" ]; then
  ./setup-wg.sh $1
  read -p "Please follow the above Wireguard instructions."
fi

# Last one, to allow wg to put its WG_DEVNUM variable into .bashrc
./setup-bashrc.sh

read -p "If this is an Nvidia machine, press enter to continue; otherwise ctrl-c to exit. (only tested on RTX 2070 on Ubuntu 18.04!)"
# Use bash to reload bashrc, so we can get apt-fast working for this big install
bash ./setup-nvidia.sh
