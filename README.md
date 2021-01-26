# Personal environment setup scripts

```
wget https://clive.io/env && bash env
```


## Note on CUDA

For WSL, do not run `setup-nvidia` and instead follow the [CUDA on WSL instructions](https://docs.nvidia.com/cuda/wsl-user-guide/index.html). At the moment I have it working with driver version `465.21` and CUDA version `11.3`. Make sure to `apt install cuda-toolkit-11-2` too (just released as of Jan 2021) to get NVCC.

For Ubuntu, this was designed to work on Ubuntu 18.04 and locks a lot of versions down [CUDA 10.1, conda 2019.10] (because CUDA did not support 20.04 at the time). I am not sure if it works anymore and it needs some version bumps anyway.

## Instructions for getting SSH into WSL2 working

WSL2's networking stack is weird in that sometimes it works as if host == wsl VM, and sometimes it doesn't.

Bulk of the instructions are sourced from [here](https://www.williamjbowman.com/blog/2020/04/25/running-a-public-server-from-wsl-2/).

> 1) In WSL, make sure your server is using IPv4. I spent a hell of a long time just trying to figure out why I couldn’t access the server from localhost. I had successfully run a handful of local http servers from WSL that were accessible from the Windows host, so I wasn’t sure what the problem was. It turns out this server, written in Java, wouldn’t work until I added -Djava.net.preferIPv4Stack=true to the java options. It appears that Java was defaulting to IPv6, and WSL doesn’t forward IPv6 properly, or something.
>
> 2) In WSL, make sure you allow the port through your WSL firewall, if you’re using one. Using a WSL firewall might be redundant, but you might be using one. I usually use ufw in my linux machines, so run I’d run ufw allow $PORT in WSL.
>
> 3) In Windows, forward your port from the public IP port to the WSL port using netsh interface portproxy add v4tov4 listenport=$PORT listenaddress=0.0.0.0 connectport=$PORT connectaddress=127.0.0.1 in a Powershell with admin rights. This is one of the hard-to-find but necessary WSL specific bits. It look like Windows creates a virtual adapter that isn’t properly bridged with your internet network adapter. I tried playing various bridging tricks, but in the end, I had to manually create a portproxy rule using Windows’ network shell netsh. This listens on all addresses and forwards the connection to the localhost, which seems to be automatically bridged with WSL. You can also try to manually forward it to the WSL adapter. Use ipconfig to find it. However, the WSL IP changes from time to time, so I recommend using local host instead. It might also be wise to listen explicitly on your internet facing IP instead of 0.0.0.0, but this seemed to work.
>
> 4) In Windows, allow the port through the Windows firewall explicitly by adding a new Inbound Rule using the Windows Defender Firewall with Advanced Security administrative tool. This is accessible as WF.msc in cmd and Powershell. Select Inbound Rule, and click New rule... in the action menu to the right, and work your way through the menu to allow the port explicitly. Normally, Windows asks if you want to allow applications through the firewall. This doesn’t seem to happen with WSL servers, so we have to manually add a rule.
>
> 5) In your router, setup port forwarding for the port.

Also, one more thing from me:

4a) It doesn't appear possible to mark the Wireguard virtual network as private, so you can set the Windows Firewall rule to only apply to private networks. As a substitute, make sure to set source IP to the Wireguard subnet, and the destination IP to the current computer's Wireguard IP.
