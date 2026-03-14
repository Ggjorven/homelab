# Network Stack

**Network Stack** is a collection of network related services + the essentials for my **Docker Compose** stacks, this folder contains the installation instructions for installing these using **Docker Compose**.

## Prerequisites

Before we can create our `network stack` on our `docker` **Proxmox LXC**. We must have finished these steps:

- [`docker`](../README.md)

## Installation

1. Go to your users `home` directory and go to your dedicated docker directory and create a new directory for `networkstack`:
    ```
    cd ~
    cd docker
    mkdir -p networkstack
    cd networkstack
    ```

2. Retrieve the compose file and .env file:
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/networkstack/compose.yaml 
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/networkstack/.env
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
    docker compose --all-resources up -d
    ```

## Configuration

### Gluetun

`gluetun` doesn't require any configuration. 

#### Port forwarding

Optionally you can enable port forwarding for a vpn.

1. Go to the `networkstack` folder:
    ```
    cd ~/docker/networkstack
    ```

2. Open the .env file:
    ```
    nano .env
    ```
    And uncomment:
    ```
    # VPNX_PORT_FORWARDING=on
    ```

3. Restart your compose stack:
    ```
    docker compose down
    docker compose up -d
    ```

4. Check the logs of `gluetun`:
    ```
    docker logs vpnX
    ```
    You should see something like:
    ```
    [ip getter] Public IP address is xxx.xxx.xxx.xxx (Netherlands, North Holland, Amsterdam - source: ipinfo+ifconfig.co+ip2location+cloudflare)
    ...
    INFO [port forwarding] My forwarded ports are 9999, the first forwarded port is 9999 and the VPN network interface is tun0
    ```
    If you don't see this output checkout the [debugging guide#forwarded-port-not-showing-up](DEBUGGING.md).

5. To double check the port is actually open run this:
    ```
    docker exec -it vpnX /bin/sh

    wget -qO port-checker https://github.com/qdm12/port-checker/releases/download/v0.4.0/port-checker_0.4.0_linux_amd64
    chmod +x port-checker

    ./port-checker --listening-address=":9999"
    ```
    Where you change `9999` to the port you say in the docker logs.

6. Open a browser and go the `gluetun` VPN's IP on port `9999` where `9999` is replaced by your actual listening port.

7. If everything works you will see a small output detailing your browser information. Something like:
    ```
    Listening address: :9999
    Client address: xxx.xxx.xxxx.xxx:xxx
    Browser: Chrome 145
    Device: Computer
    OS: Linux 0
    ```

8. (Optional) To be able to use this port dynamically in other applications we also want to setup `gluetun` authentication. First we'll need to generate an api key:
    ```
    docker run --rm -v ./vpnX:/gluetun qmcgaw/gluetun genkey
    ```
    Make sure to save this API key for later.

9. Create a new directory for setting up a safe path that someone with the API key can retrieve the dynamic port.
    ```
    sudo mkdir -p vpnX/auth
    ```

10. Create a config file that sets up a route like so:
    ```
    sudo rm vpnX/auth/config.toml
    sudo nano vpnX/auth/config.toml
    ```
    And paste:
    ```
    [[roles]]
    name = "portchecker"
    routes = ["GET /v1/portforward", "GET /v1/openvpn/portforwarded", "GET /v1/publicip/ip"]
    auth = "apikey"
    apikey = "<APIKEY>"
    ```
    Replace `<APIKEY>` with your generated API Key.

If you have any other issues I have taken these instructions from [here](https://github.com/TechClusterHQ/qbt-portchecker/tree/main).

## Start on boot-up

To make this stack start on the boot-up of the LXC follow [these instructions](../BOOT-UP.md#adding-a-stack).

## Debugging

If you have any issues setting up `networkstack` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Docker](https://www.docker.com/) - Hardware accelerated containers
- [Gluetun](https://gluetun.com/) - VPN Container
- [Flaresolverr](https://github.com/FlareSolverr/FlareSolverr) - Cloudfare solver
