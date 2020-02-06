#!/bin/bash

sudo apt -y install openssh-server
sudo service sshd start
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDcn0Fqr2VEpUDgak6ZfXI+NMDBzNdEVMpnAbkpuLOGWPpjk5r/67CgSIVVB08Kegc4HtCg4oYqCysmJv8A0pgrZf1gKjcWP51zwldsEOriLEvwXZfwyKoG7wtFRauT+GxyOZt5x02MqerMkWlhoMnXXA/iD9HWrLnqsqIblkygZ7Ifz4nuUA5Kn9FoHWKbqUVv7hTkW9UvuQreYjhgE8nwVBSz13hEIYyqmLhbEuGmGcMNXs/2/1xLr8WipsiXdwOxrfXeuye1tuAw+1Boi6jMGU0dymVqKzsNevXjbi61Lksm6KZWzs2Sh44LAlbEjQ9p3KU85sdUEHVvOEQse5Ol" >> ~/.ssh/authorized_keys
# There's gotta be a better way to do key management, right?

for keyfile in /etc/ssh/ssh_host_*_key; do
  sudo ssh-keygen -lf $keyfile
done

ssh-keygen
cat ~/.ssh/id_rsa.pub
