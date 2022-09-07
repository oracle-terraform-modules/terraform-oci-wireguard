#! /usr/bin/bash

echo "net.ipv4.ip_forward = 1" > /etc/sysctl.conf && sysctl -p

firewall-offline-cmd --add-service=wireguard && systemctl restart firewalld

mkdir -p /root/wireguard && wg genkey | tee /root/wireguard/privatekey | wg pubkey > /root/wireguard/publickey

SERVER_PRIVATE_KEY=$(cat /root/wireguard/privatekey)
export SERVER_PRIVATE_KEY

sed -i "s?SERVER_PRIVATE_KEY?$SERVER_PRIVATE_KEY?g" /root/wireguard/wg0.conf

mv /root/wireguard/wg0.conf /etc/wireguard
