#!/bin/bash

# 1. Install packages
apt install ipset iptables-persistent -y

# 2. Create Cloudflare IP set
ipset create cloudflare hash:net

# 3. Populate it
for cidr in $(curl -s https://www.cloudflare.com/ips-v4); do
    ipset add cloudflare $cidr
done

# 4. Verify — should show ~15
ipset list cloudflare | grep -c "/"
