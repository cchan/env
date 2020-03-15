#!/bin/bash
set -e

# This script does client setup.

# For the server:
# /etc/wireguard/wg0.conf contains:
#[Interface]
#Address = 10.0.0.1/24
#SaveConfig = true
#ListenPort = 51820
#PrivateKey = uIJ9YsKfNuK+m/X+BULBo/cUCO2bvYAeBMUvglR4M2s=
# Then set net.ipv4.ip_forward=1 in /etc/sysctl.conf
# and sudo sysctl -p


[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

if [ -f "/etc/wireguard/wg0.conf" ]; then
  echo "/etc/wireguard/wg0.conf already exists."
  exit 1
fi

if [ -z "$1" ]; then
  echo "Need a unique device number parameter (1-255)."
  exit 1
fi

DEVNUM=$1

if [[ "$(whoami)" -eq "pi" ]]; then
  # https://github.com/adrianmihalko/raspberrypiwireguard/wiki/Install-WireGuard-on-Raspberry-Pi-1,-2-(not-v1.2),-Zero,-Zero-W
  read -p "If this is a raspberry pi 1, 2, zero, or zero w, this won't work. Continue?"
  # https://www.reddit.com/r/pihole/comments/bnihyz/guide_how_to_install_wireguard_on_a_raspberry_pi/
  apt -y install raspberrypi-kernel-headers libelf-dev libmnl-dev build-essential git
  echo "deb http://deb.debian.org/debian/ unstable main" > /etc/apt/sources.list.d/unstable.list
  printf "Package: *\nPin: release a=unstable\nPin-Priority: 90\n" > /etc/apt/preferences.d/limit-unstable
  apt-key adv --keyserver   keyserver.ubuntu.com --recv-keys 7638D0442B90D010 # apparently dirmngr is included in newer pi images
  apt-key adv --keyserver   keyserver.ubuntu.com --recv-keys 04EE7237B7D453EC
  apt update
  apt -y install wireguard
else
  add-apt-repository -y ppa:wireguard/wireguard
  apt -y install wireguard
fi


PRIVKEY=$(wg genkey)
PUBKEY=$(echo $PRIVKEY | wg pubkey)

cat << EOF > /etc/wireguard/wg0.conf
[Interface]
PrivateKey = $PRIVKEY
Address = 10.0.0.$DEVNUM/24

[Peer]
PublicKey = w6Pdn0bsHMlfUH2AQxViDQf/1XyAKzbT0bJcCxDpoVE=
Endpoint = wg.clive.io:51820
AllowedIPs = 10.0.0.0/24
PersistentKeepalive = 25
EOF

echo "export WG_DEVNUM=$WG_DEVNUM" >> ~/.bashrc

echo "Run on the server:"
echo "sudo wg set wg0 peer $PUBKEY allowed-ips 10.0.0.$DEVNUM/32 && sudo wg-quick save wg0"
echo "Then run here:"
echo "sudo wg-quick up wg0 && sudo systemctl enable wg-quick@wg0"
