#!/bin/bash

[ "$UID" -eq 0 ] || exec sudo bash "$0" "$@"

if [ -f "/etc/wireguard/wg0.conf" ]; then
  echo "/etc/wireguard/wg0.conf already exists."
  exit 1
fi

if [ -z "$1" ]; then
  echo "Need a unique device number parameter."
  exit 1
fi

DEVNUM=$1

add-apt-repository -y ppa:wireguard/wireguard
apt -y install wireguard

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

echo "Run on the server:"
echo "sudo wg set wg0 peer $PUBKEY allowed-ips 10.0.0.$DEVNUM/32"
echo "Then run here:"
echo "sudo wg-quick up wg0 && sudo systemctl enable wg-quick@wg0"
