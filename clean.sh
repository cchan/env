# This is less of a script than a list of tricks. Fairly Ubuntu-specific.

# Things to do once
echo 'SystemMaxUse=300M' | sudo tee -a /etc/systemd/journald.conf
sudo systemctl restart systemd-journald
sudo snap set system refresh.retain=2
sudo apt install zram-config
sudo swapoff -a && sudo fallocate -l 0.5G /swapfile && sudo mkswap /swapfile && sudo swapon /swapfile

# Things to do every time
sudo apt clean && sudo apt purge && sudo apt prune
conda clean
LANG=C snap list --all | awk '/disabled/{print $1, $3}' | while read name rev; do sudo snap remove "$name" --revision="$rev"; done
rm -rf ~/.cache ~/.go ~/snap
sudo apt remove $(dpkg-query --show 'linux-modules-*' | cut -f1 | grep -v "$(uname -r)")  # May need to manually rm from /lib/modules too
