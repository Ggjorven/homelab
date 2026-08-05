#!/bin/bash

for cidr in $(curl -s https://www.cloudflare.com/ips-v4); do
    ipset add cloudflare $cidr 2>/dev/null
done

netfilter-persistent save
