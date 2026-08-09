# priv-net

`priv-net` is a **Proxmox LXC** on the **Proxmox Node** with **docker** and **docker compose** installed.  
This folder contains the installation instructions and configuration files used for this device.

## Steps

1. From the **Proxmox** WebUI navigate to the **Node**'s **Shell**.

2. Start creation of a **Docker LXC** using the [community script](https://community-scripts.org/scripts/docker):
    ```
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
    ```

3. Choose `Advanced Install`. 

4. Choose **Unpriviliged**, set a safe root password, set the container ID to `113` (matches with the VLAN) and set the hostname to `priv-net` (or something else).

5. For the `priv-net` LXC I have given it a disk of **10GB**, **1vCPU**s and **512MiB** of RAM.

6. For the (primary) **Network Bridge** select `vmbr1` and set a static IP (since we don't have a DHCP server). Set the IP to `172.20.113.10/24` and the gateway to `172.20.113.1`. For IPv6 select `none`.

7. Leave **MTU Size** blank, same for **DNS search domain**, **DNS server IP** and **MAC-address**.

8. Set the **VLAN tag** to `113` to get the proper firewall rules.

9. You can keep the **Tags** as default or set it to something custom like: `docker;proxy`.

10. Provision the SSH for root by using the `found` option (or provide your own). Use space to select the key. And enable `root` SSH access.

11. Leave **FUSE support** disabled, enable **TUN/TAP** support.

12. **Enable nesting**, but disable **GPU passthrough**.

13. Leave **APT-cacher** disabled and don't set a **HTTP/HTTPS proxy**.

14. Set your **Timezone** to your timezone, mine is `Europe/Amsterdam`.

15. (Optional) Personally I like to have **Container protection** enabled to avoid accidental deletion.

16. Set **Allow device node creation** to No and leave **Filesystem mounts** empty. Same for the **Post-install hook**.

17. (Optional) If you want verbose output during installation enable it. (I like it)

18. Confirm the settings and wait... (If you're asked to update the defaults just hit Cancel)

19. When it asks you to install **Portainer** select **N**. Same for the **Portainer Agent**.

20. Also don't expose the **Docker TCP Socket**, so **N**.

21. Now that the container is installed go to the **LXC** in the WebUI and go to **Network**.

22. Double click on `net0`/`eth0`/`vmbr1` and disable the **Firewall**, since we'll be setting up our own firewall rules.

23. For debugging I also like to **Add** another **Network Device**. 

24. Set the **Name** to `eth1`. Set the **Bridge** to `vmbr0` and disable the **Firewall**.

25. Set **IPv4** to **DHCP** (since it's only for debugging) and set **IPv6** to **Static** and leave it empty. **Add**!

26. Reboot the **LXC** to apply the changes.

27. Now go to **LXC**'s **Shell** and login with `root` and the password you set in the installation.

28. Create a `privnet` group and user in the LXC using:
    ```sh
    groupadd -g 1000 privnet
    useradd -u 1000 -g 1000 -m -s /bin/bash privnet
    usermod -aG docker privnet
    usermod -aG sudo privnet
    ```

29. Set a (safe) password for the `privnet` user:
    ```sh
    passwd privnet
    ```

30. Now login as the `media` user:
    ```sh
    su privnet
    ```

31. Now we're going to install all of the files. Start by navigating to the `home` directory:
    ```sh
    cd ~/
    ```

32. Get the global .env:
    ```sh
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/.env
    ```

33. Create the `networking` stack:
    ```sh
    mkdir -p ~/networking
    cd ~/networking
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/networking/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/networking/compose.yaml
    ```

34. Create the `monitoring` stack:
    ```sh
    mkdir -p ~/monitoring
    cd ~/monitoring
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/monitoring/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/monitoring/compose.yaml
    ```

35. Create the `certbot` stack:
    ```sh
    mkdir -p ~/certbot
    cd ~/certbot
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/certbot/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/certbot/compose.yaml
    ```

36. Create the `openresty` stack:
    ```sh
    mkdir -p ~/openresty
    cd ~/openresty
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/openresty/.env
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/openresty/compose.yaml
    # TODO: Files
    ```

37. Get the `up` and `down` scripts:
    ```sh
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/scripts/up-networking.sh
    sudo chmod +x up-networking.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/scripts/up-monitoring.sh
    sudo chmod +x up-monitoring.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/scripts/up-certbot.sh
    sudo chmod +x up-certbot.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/scripts/up-openresty.sh
    sudo chmod +x up-openresty.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/scripts/down-networking.sh
    sudo chmod +x down-networking.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/scripts/down-monitoring.sh
    sudo chmod +x down-monitoring.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/scripts/down-openresty.sh
    sudo chmod +x down-openresty.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/scripts/down-certbot.sh
    sudo chmod +x down-certbot.sh
    ```

38. Also get the `compose-boot`, `compose-shutdown` and `compose-restart` scripts and services:
    ```sh
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/scripts/compose-boot.sh
    sudo chmod +x compose-boot.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/scripts/compose-shutdown.sh
    sudo chmod +x compose-shutdown.sh
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/scripts/compose-restart.sh
    sudo chmod +x compose-restart.sh
    cd /etc/systemd/system
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/services/compose-boot.service
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/priv-net/services/compose-shutdown.service
    ```

39. Enable the `systemctl` for `compose-boot` and `compose-shutdown`:
    ```sh
    sudo systemctl daemon-reload
    sudo systemctl enable compose-boot
    sudo systemctl enable compose-shutdown
    ```

40. Before we can continue you must create an account at [cloudflare.com](https://dash.cloudflare.com/sign-up).

41. Go to **Domains**, and add your domain name. Make sure `Import DNS records automatically` is enabled.

42. Go to where you bought your domain and change the **DNS Records** to the DNS Records cloudflare provides you with.

43. To make our `priv-net` be able to change DNS records and create SSL records we need to create an API Key. Go to **Profile** -> **API Tokens**.

44. Click **Create Token**, select **Edit Zone DNS**.

45. Under **Zone Resources** click `Select...` and select your domain. Scroll to the bottom and **Continue** and **Create**.

46. Copy the API token to a temporary safe location since we are going to need it multiple times.

47. Go back to your domain on the dashboard and go to **DNS** -> **Records**.

48. Create records for all of these:
    - `jellyfin.local`
    
    For the IP address set the value of `ip a` of network interface `vmbr0`/`eth1`.

49. Now we can generate our SSL certificates:
    ```sh
    cd ~/certbot

    LOCAL_DOMAIN="local.mydomain.com"
    CF_API_TOKEN="your_token_here"
    EMAIL="invalid@invalid.invalid"

    echo "dns_cloudflare_api_token = ${CF_API_TOKEN}" > cloudflare.ini
    chmod 600 cloudflare.ini

    docker run --rm \
        -v "$(pwd)/certs:/etc/letsencrypt" \
        -v "$(pwd)/cloudflare.ini:/cloudflare.ini:ro" \
        certbot/dns-cloudflare:latest certonly \
            --dns-cloudflare \
            --dns-cloudflare-credentials /cloudflare.ini \
            -d "${LOCAL_DOMAIN}" \
            -d "*.${LOCAL_DOMAIN}" \
            --email "${EMAIL}" \
            --agree-tos --no-eff-email --non-interactive

    rm cloudflare.ini
    ```
    Edit the `LOCAL_DOMAIN` to have be your actual domain and `CF_API_TOKEN` to be the actual token, finally set `EMAIL` to your actual email to receive alerts if it fails.

50. We want our SSL certificates to also auto-renew, so edit the `.env` for `certbot`:
    ```sh
    cd ~/certbot
    nano .env
    ```
    Change the `CF_API_TOKEN` to the previously created token.  
    Set the `LOCAL_DOMAIN` to the same `local.mydomain.com` you set earlier.  
    Finally set the `EMAIL` to a real email for notifications about your certificates.

51. TODO: openresty

## Configuration

// TODO: aaa

## Debugging

If you have any issues setting up `priv-net` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## Extra 

To update a compose stack's images just run:
```
docker compose down
docker compose pull
docker compose up -d
docker image prune
```
In the stack's directory

To remove all docker containers and their remains run:

> [!CAUTION]
> This action is irreversible and will delete docker containers and networks.

```
docker stop $(docker ps -a -q)
docker rm $(docker ps -a -q)
docker network prune
```
To also delete cached images run:
```
docker image prune
```
