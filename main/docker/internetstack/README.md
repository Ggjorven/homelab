# Internet Stack

**Internet Stack** is a collection of services related to safely exposing other services to the world wide web, this folder contains the installation instructions for installing these using **Docker Compose**.

## Prerequisites

Before we can create our `internet stack` on our `docker` **Proxmox LXC**. We must have finished these steps:

- [`docker`](../README.md)
- [`networkstack`](../networkstack/README.md)

## Installation

1. Go to your users `home` directory and go to your dedicated docker directory and create a new directory for `internetstack`:
    ```
    cd ~
    cd docker
    mkdir -p internetstack
    cd internetstack
    ```

2. Retrieve the compose file and .env file:
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/internetstack/compose.yaml 
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/internetstack/.env
    ```

3. Before we can edit our .env we must identify our user. This is done with:
    ```
    id <yourusername>
    ```
    Take note of `uid` and `gid`.

4. Now open up your .env file:
    ```
    nano .env
    ```

4. Modify `PUID` to reflect your `uid` and `PGID` to reflect `gid`.

5. Before we can continue you must create an account at [cloudflare.com](https://dash.cloudflare.com/sign-up).

6. Go to **Domains**, and add your domain name. Make sure `Import DNS records automatically` is enabled.

7. Go to where you bought your domain and change the **DNS Records** to the DNS Records cloudflare provides you with.

8. To make our `internetstack` be able to change DNS records for DDNS we need to create an API Key. Go to **Profile** -> **API Tokens**.

9. Click **Create Token**, select **Edit Zone DNS**.

10. Under **Zone Resources** click `Select...` and select your domain. Scroll to the bottom and **Continue** and **Create**.

11. Now go back to the open .env file and paste the API Token under:
    ```
    # Cloudflare settings
    CLOUDFLARE_API_TOKEN=apitoken
    ```

12. Now add your domains under:
    ```
    # Domains
    AUTH_DOMAIN=auth.yourdomain.com
    JELLYFIN_DOMAIN=jellyfin.yourdomain.com
    NAVIDROME_DOMAIN=navidrome.yourdomain.com
    ```

13. Set auth settings in .env // TODO: ...

14. Set fail2ban settings in .env

15. Now we can start setting up fail2ban files:
    ```
    mkdir -p fail2ban
    mkdir -p fail2ban/filter.d
    ```

16. Clone the template files into the proper directories:
    ```
    cd fail2ban
    # TODO: ...
    cd ../..
    ```

17. Before we are ready to start this stack though we'll want to set some iptables rules. Start by installing the dependencies:
    ```
    wget -qO- https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/internetstack/scripts/install-dependencies.sh | bash
    ```

18. Before we are ready to start this stack though we'll want to set some iptables rules. Now download the rule installation script:
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/internetstack/scripts/install-rules.sh
    ```

19. Before editing the file we must know what our subnet is, check this with:
    ```
    ip a
    ```
    You should see something like `192.168.0.x/24`, where the `/24` is important.

20. Now modify the script and set `SUBNET` to your actual subnet like `/24` or `/22`, keep the `192.168.0.0` intact.
    ```
    nano install-rules.sh
    ```

21. Now run the script:
    ```
    chmod +x install-rules.sh
    ./install-rules.sh
    rm install-rules.sh
    ```

22. To make sure the definition of an IP from cloudflare stays consistent with what cloudflare IP's actually are I have created a **systemd** service. To install this run:
    ```
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/internetstack/scripts/update-cloudflare-ips.sh
    cd /etc/systemd/system
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/internetstack/services/update-cloudflare-ips.service
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/internetstack/services/update-cloudflare-ips.timer
    ```

23. Now enable this service with:
    ```
    sudo systemctl daemon-reload
    sudo systemctl start update-cloudflare-ips.timer
    sudo systemctl enable update-cloudflare-ips.timer
    ```

24. // TODO: Add nginx files to networkstack

25. After all these steps we are finally ready to start the containers:
    ```
    docker compose up -d
    ```

## Configuration

### Cloudflare-DDNS

Cloudflare-DDNS has been preconfigured.

### Authelia

// TODO: ...

### Fail2ban

// TODO: ...

## Start on boot-up

To make this stack start on the boot-up of the LXC follow [these instructions](../BOOT-UP.md#adding-a-stack).

## Debugging

If you have any issues setting up `internetstack` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Docker](https://www.docker.com/) - Hardware accelerated containers
- [Cloudflare](https://www.cloudflare.com) - Safe DNS server
- [Certbot](https://certbot.eff.org/) - Easy SSL certificates from Let's Encrypt
- [Authelia](https://www.authelia.com/) - Authentication and Authorization server
- [Fail2ban](https://www.authelia.com/) - Daemon that bans hosts with multiple auth errors
