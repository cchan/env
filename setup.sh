#!/bin/bash
set -e

# wget https://clive.io/env && bash env <DEVICE_ID>

if [ -z "$1" ]; then
  echo "Need a unique device number parameter (1-255) for Wireguard."
  exit 1
fi

mkdir -p ~/code
cd ~/code
sudo apt -y install git
git clone https://github.com/cchan/env
cd env

./setup-apt-fast.sh
./setup-conda.sh
./setup-ssh.sh
read -p "Please SSH into the machine, update known_hosts as needed, and add the above pubkey to GitHub. Then press enter to continue."

./setup-git.sh
./setup-wg.sh $1
read -p "Please follow the above Wireguard instructions."

./setup-bashrc.sh

# Use bash to reload bashrc, so we can get apt-fast working for this big install
bash ./setup-nvidia.sh
