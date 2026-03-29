#!/bin/bash

iptables -F
iptables -X
iptables -F DOCKER-USER
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT

netfilter-persistent save
