#!/bin/bash

# Flush all custom rules
sudo iptables -F INPUT
sudo iptables -F DOCKER-USER

# Reset default policies to ACCEPT
sudo iptables -P INPUT ACCEPT
sudo iptables -P FORWARD ACCEPT

# Save cleared state
netfilter-persistent save
