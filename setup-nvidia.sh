#!/bin/bash
set -e

# Selected minimal install and no graphics + third party stuff in the 18.04 installer.

# Install latest nvidia driver (never mind just apt-get install cuda below and it'll get all the driver stuff too)
#sudo apt install -y build-essential pkg-config libglvnd-dev
#wget https://us.download.nvidia.com/XFree86/Linux-x86_64/495.46/NVIDIA-Linux-x86_64-495.46.run
#chmod +x NVIDIA-Linux-x86_64-495.46.run
#sudo ./NVIDIA-Linux-x86_64-495.46.run

# Install cuda toolkit via the recommended way: https://developer.nvidia.com/cuda-downloads?target_os=Linux&target_arch=x86_64&Distribution=Ubuntu&target_version=22.04&target_type=deb_local
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-ubuntu2204.pin
sudo mv cuda-ubuntu2204.pin /etc/apt/preferences.d/cuda-repository-pin-600
wget https://developer.download.nvidia.com/compute/cuda/11.7.1/local_installers/cuda-repo-ubuntu2204-11-7-local_11.7.1-515.65.01-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu2204-11-7-local_11.7.1-515.65.01-1_amd64.deb
sudo cp /var/cuda-repo-ubuntu2204-11-7-local/cuda-*-keyring.gpg /usr/share/keyrings/
sudo apt-get update
sudo apt-get -y install cuda
# sudo apt -y install cuda # https://github.com/ValveSoftware/steam-for-linux/issues/5778#issuecomment-598511238
# sudo apt -y install cuda-toolkit-10-2 cuda-tools-10-2 cuda-compiler-10-2 cuda-libraries-10-2 cuda-libraries-dev-10-2

# According to the postinstall instructions on https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html#post-installation-actions
export PATH=/usr/local/cuda-11.7/bin${PATH:+:${PATH}} # /usr/local/cuda-10.2/NsightCompute-2019.1 ?
echo 'export PATH=/usr/local/cuda-11.7/bin${PATH:+:${PATH}}' >> ~/.bashrc

# useful packages!
# As advised on https://pytorch.org/
conda install pytorch torchvision torchaudio cudatoolkit=11.6 -c pytorch -c conda-forge  # Alternatively, can try installing cuda from conda's nvidia/cuda channel, and ignore everything but driver install above
pip install pycuda

echo "Rebooting. After the reboot, run these to test the installation:"
echo "inxi -G"
echo "nvidia-smi"
echo "nvcc --version"
echo "python -c 'import torch;print(torch.cuda.is_available())'"
echo "python ~/code/env/pycuda_test.py"

# sudo reboot









#echo Just use https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html
#echo Also make sure to get CuDNN.

#[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"
#apt-get purge nvidia*
#add-apt-repository ppa:graphics-drivers/ppa
#apt update
#apt install nvidia-driver-440
#echo "Rebooting now. Try lsmod | grep nvidia to check after the reboot."
#reboot

# To unload nouveau:
#service gdm3 stop
#echo 0 > /sys/class/vtconsole/vtcon1/bind
#rmmod nouveau
#modprobe nvidia
#service gdm3 start
# Also just try unplugging the monitor and rebooting.
