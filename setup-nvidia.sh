#!/bin/bash
set -e

# Selected minimal install and no graphics + third party stuff in the 18.04 installer.

# Install latest nvidia driver (440)
#sudo add-apt-repository ppa:graphics-drivers/ppa
#sudo apt update
#sudo apt -y install nvidia-driver-440 # nvidia drivers are backwards compatible with older cudatoolkits.
# Actually this works better (it successfully gives you the display drivers)
wget http://us.download.nvidia.com/XFree86/Linux-x86_64/440.59/NVIDIA-Linux-x86_64-440.59.run
chmod +x NVIDIA-Linux-x86_64-440.59.run
./NVIDIA-Linux-x86_64-440.59.run

# Install cuda toolkit via the recommended way
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/cuda-ubuntu1804.pin
sudo mv cuda-ubuntu1804.pin /etc/apt/preferences.d/cuda-repository-pin-600
sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
sudo add-apt-repository "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /"
sudo apt update
# sudo apt -y install cuda # https://github.com/ValveSoftware/steam-for-linux/issues/5778#issuecomment-598511238
sudo apt -y install cuda-toolkit-10-2 cuda-tools-10-2 cuda-compiler-10-2 cuda-libraries-10-2 cuda-libraries-dev-10-2

# According to the postinstall instructions on https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#post-installation-actions
export PATH=/usr/local/cuda-10.2/bin:/usr/local/cuda-10.2/NsightCompute-2019.1${PATH:+:${PATH}}
echo 'export PATH=/usr/local/cuda-10.2/bin:/usr/local/cuda-10.2/NsightCompute-2019.1${PATH:+:${PATH}}' >> ~/.bashrc

# Not sure if 10.2 or 10.1
conda install pytorch torchvision cudatoolkit=10.2 -c pytorch

pip install pycuda

echo "Rebooting. After the reboot, run these to test the installation:"
echo "inxi -G"
echo "nvidia-smi"
echo "nvcc --version"
echo "python -c 'import torch;print(torch.cuda.is_available())'"
echo "python ~/code/env/pycuda_test.py"

sudo reboot





#echo Just use https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html
#echo Also make sure to get CuDNN.

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
