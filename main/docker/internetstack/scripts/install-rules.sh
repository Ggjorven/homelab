#!/bin/bash

SUBNET=192.168.0.0/24

# INPUT chain — protects the host
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -s ${SUBNET} -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -m set --match-set cloudflare src -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -m set --match-set cloudflare src -j ACCEPT
sudo iptables -P INPUT DROP

# DOCKER-USER chain — protects docker-exposed ports
# Allow LAN full access to all ports
sudo iptables -I DOCKER-USER -s ${SUBNET} -j ACCEPT
# Allow Cloudflare IPs to reach 80 and 443
sudo iptables -A DOCKER-USER -p tcp --dport 80 -m set --match-set cloudflare src -j ACCEPT
sudo iptables -A DOCKER-USER -p tcp --dport 443 -m set --match-set cloudflare src -j ACCEPT
# Drop everything else
sudo iptables -A DOCKER-USER -j DROP

# Save so rules survive reboot
netfilter-persistent save
