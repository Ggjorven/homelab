# Gluetun

**Gluetun** is a VPN Container for my **Docker Compose** stacks, this branch contains the installation instructions for installing **Gluetun** using **Docker Compose**.

## Prerequisites

Before we can create our `*arr stack` on our `docker` **Proxmox LXC**. We must have finished these steps:

- [`docker`](../README.md)

## Installation

1. Go to your users `home` directory and go to your dedicated docker directory and create a new directory for `gluetun`:
    ```
    cd ~
    cd docker
    mkdir -p gluetun
    cd gluetun
    ```

2. Retrieve the compose file and .env file:
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/gluetun/compose.yaml 
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/gluetun/.env
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

5. Now we must change our credentials under:
    ```
    OPENVPN_USER=username
    OPENVPN_PASSWORD=password
    ```
    To reflect your actual PIA login details.

6. We are now ready to start our docker stack.
    ```
    docker compose up -d
    ```

## Configuration

`gluetun` doesn't require any configuration. Though `gluetun` with `pia` can also enable port forwarding. I have added some instructions for this here.

1. Go to the `gluetun` folder:
    ```
    cd ~/docker/gluetun
    ```

2. Open the compose file:
    ```
    nano compose.yaml
    ```
    And under environment add:
    ```
    - VPN_PORT_FORWARDING=on
    - VPN_PORT_FORWARDING_UP_COMMAND=/bin/sh -c "echo My forwarded ports are {{PORTS}}, the first forwarded port is {{PORT}} and the VPN network interface is {{VPN_INTERFACE}}" 
    ```

3. Restart your compose stack:
    ```
    docker compose down
    docker compose up -d
    ```

4. Check the logs of `gluetun`:
    ```
    docker logs gluetun
    ```
    You should see something like:
    ```
    [ip getter] Public IP address is xxx.xxx.xxx.xxx (Netherlands, North Holland, Amsterdam - source: ipinfo+ifconfig.co+ip2location+cloudflare)
    ...
    INFO [port forwarding] My forwarded ports are 9999, the first forwarded port is 9999 and the VPN network interface is tun0
    ```

5. To double check the port is actually open run this:
    ```
    docker exec -it gluetun /bin/sh

    wget -qO port-checker https://github.com/qdm12/port-checker/releases/download/v0.4.0/port-checker_0.4.0_linux_amd64
    chmod +x port-checker

    ./port-checker --listening-address=":9999"
    ```
    Where you change `9999` to the port you say in the docker logs.

6. Open a browser and go the `gluetun` VPN's IP on port `9999` where `9999` is replaced by your actual listening port.

7. If everything works you will see a small output detailing your browser information.

8. (Optional) To be able to use this port dynamically in other applications we also want to setup `gluetun` authentication. First we'll need to generate an api key:
    ```
    docker run --rm -v ./gluetun:/gluetun qmcgaw/gluetun genkey
    ```
    Make sure to save this API key for later.

9. Create a new directory for setting up a safe path that someone with the API key can retrieve the dynamic port.
    ```
    mkdir -p gluetun/auth
    ```

10. Create a config file that sets up a route like so:
    ```
    rm gluetun/auth/config.toml
    nano gluetun/auth/config.toml
    ```
    And paste:
    ```
    [[roles]]
    name = "portchecker"
    routes = ["GET /v1/portforward", "GET /v1/openvpn/portforwarded"]
    auth = "apikey"
    apikey = "<APIKEY>"
    ```
    Replace `<APIKEY>` with your generated API Key.

If you have any issues I have taken these instructions from [here](https://github.com/TechClusterHQ/qbt-portchecker/tree/main).

## Start on boot-up

To make `gluetun` start-up on boot we can set up a **systemd** service. I have created a compose-boot service for this purpose.  

1. First make sure we have a folder for our script:
    ```
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    ```

2. Now download my compose-boot script (if you have already downloaded it before, you can skip this):
    ```
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/scripts/compose-boot.sh
    sudo chmod +x compose-boot.sh
    ```

3. Modify this script.
    ```
    sudo nano compose-boot.sh
    ```
    Either add a `docker compose up -d` for your new stack or replace the existing one.  
    Modify `<username>` to reflect your linux user's username.
    ```
    cd /home/<username>/docker/gluetun
    docker compose up -d
    ```
    Eventually this script will contain all the stacks that need to start on start-up.

4. If you have already set up the **systemd** service you can skip the next steps. But now we need to create a **systemd** service to run this script on start-up.
    ```
    cd /etc/systemd/system
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/services/compose-boot.service
    ```

5. Modify the **systemd** service:
    ```
    sudo nano compose-boot.service
    ```
    And change `User` and `Group` to reflect your linux user's username:
    ```
    User=<username>
    Group=<username>
    ```

6. Now enable this service:
    ```
    sudo systemctl daemon-reload
    sudo systemctl enable compose-boot
    ```

## Debugging

If you have any issues setting up `immich` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Docker](https://www.docker.com/) - Hardware accelerated containers
- [Gluetun](https://gluetun.com/) - VPN Container
