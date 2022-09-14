#!/bin/bash
set -e

# Set up SSH server
sudo apt -y install openssh-server

sudo sh -c "echo 'AllowUsers $(whoami)' >> /etc/ssh/sshd_config"
sudo sh -c "echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config"
sudo sh -c "echo 'ChallengeResponseAuthentication no' >> /etc/ssh/sshd_config"
sudo sh -c "echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config"
# I'm not sure that these directives actually do anything. First directive wins for a given directive.

# Consider checking sudo cat /etc/shadow | cut -d: -f2 to make sure no users can log in with password.
# Consider deluser'ing any users with shells.
sudo service sshd restart

mkdir -p ~/.ssh

# Authorize user to log in
#echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcn0Fqr2VEpUDgak6ZfXI+NMDBzNdEVMpnAbkpuLOGWPpjk5r/67CgSIVVB08Kegc4HtCg4oYqCysmJv8A0pgrZf1gKjcWP51zwldsEOriLEvwXZfwyKoG7wtFRauT+GxyOZt5x02MqerMkWlhoMnXXA/iD9HWrLnqsqIblkygZ7Ifz4nuUA5Kn9FoHWKbqUVv7hTkW9UvuQreYjhgE8nwVBSz13hEIYyqmLhbEuGmGcMNXs/2/1xLr8WipsiXdwOxrfXeuye1tuAw+1Boi6jMGU0dymVqKzsNevXjbi61Lksm6KZWzs2Sh44LAlbEjQ9p3KU85sdUEHVvOEQse5Ol" >> ~/.ssh/authorized_keys
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILEN8nEomCMXfELIQm3sKXUgmz9INrLo9CAuG/lN00s6" >> ~/.ssh/authorized_keys
# There's gotta be a better way to do key management, right?

ssh-keygen -t ed25519
cat ~/.ssh/id_ed25519.pub

for keyfile in /etc/ssh/ssh_host_*_key; do
  sudo ssh-keygen -lf $keyfile
done
