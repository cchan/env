#!/bin/bash
sudo apt -y install git
git clone https://github.com/cchan/env
cd env
./setup-apt-fast.sh
./setup-git.sh
./setup-bashrc.sh
./setup-ssh.sh
./setup-wg.sh
