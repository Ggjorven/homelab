#!/bin/bash

SUBNET=192.168.0.0/24

# INPUT chain — protects the host
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -s ${SUBNET} -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -m set --match-set cloudflare src -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -m set --match-set cloudflare src -j ACCEPT
sudo iptables -P INPUT DROP

# Save so rules survive reboot
netfilter-persistent save
