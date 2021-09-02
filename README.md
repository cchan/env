# Personal environment setup scripts

```
wget https://clive.io/env && bash env
```

## Note on MacOS
First install brew in default Intel `/usr/local` plus Apple Silicon `/opt/homebrew/bin/bash`
```
echo /opt/homebrew/bin/bash | sudo tee -a /etc/shells
chsh -s /opt/homebrew/bin/bash
```

Also brew install fzf, fd, ripgrep, bat

## Note on CUDA

For WSL, do not run `setup-nvidia` and instead follow the [CUDA on WSL instructions](https://docs.nvidia.com/cuda/wsl-user-guide/index.html). At the moment I have it working with driver version `465.21` and CUDA version `11.3`. Make sure to `apt install cuda-toolkit-11-2` too (just released as of Jan 2021) to get NVCC.

For Ubuntu, this was designed to work on Ubuntu 18.04 and locks a lot of versions down [CUDA 10.1, conda 2019.10] (because CUDA did not support 20.04 at the time). I am not sure if it works anymore and it needs some version bumps anyway.

## Instructions for getting persistent SSH into WSL2 working

WSL2's networking stack is weird in that sometimes it works as if host == wsl VM, and sometimes it doesn't.

This is derived from [here](https://www.williamjbowman.com/blog/2020/04/25/running-a-public-server-from-wsl-2/).

1) Install Wireguard on the host Windows system and connect to the VPN.

2) Get ssh to listen on a different port (I think Windows sometimes uses 22)
```
echo 'Port 2222' | sudo tee /etc/ssh/sshd_config
```
Also make sure sshd is using ipv4. By default it does both v4 and v6 which is good.

3) Put this in some `.bat` file
```
set PORT=2222
set MY_WG_IP=10.0.0.5
netsh interface portproxy add v4tov4 listenport=%PORT% listenaddress=%MY_WG_IP% connectport=%PORT% connectaddress=127.0.0.1
wsl -u root service ssh start
```
- Last command also keeps WSL turned on forever, as desired

And then add a shortcut to `C:\Users\<USER>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup`, then on that shortcut check `Properties > Shortcut > Advanced... > Run as Administrator`.

4) Firewall setup

> In Windows, allow the port through the Windows firewall explicitly by adding a new Inbound Rule using the Windows Defender Firewall with Advanced Security administrative tool. This is accessible as WF.msc in cmd and Powershell. Select Inbound Rule, and click New rule... in the action menu to the right, and work your way through the menu to allow the port explicitly. Normally, Windows asks if you want to allow applications through the firewall. This doesn’t seem to happen with WSL servers, so we have to manually add a rule.

Additionally, it doesn't appear possible to mark the Wireguard virtual network as private, so you can set the Windows Firewall rule to only apply to private networks. As a substitute, make sure to set source IP to the Wireguard subnet, and the destination IP to the current computer's Wireguard IP.
