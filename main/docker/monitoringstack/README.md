# Monitoring Stack

**Monitoring Stack** is a collection of monitoring related services like: **Scrutiny** (disk monitoring) & **Diun** (image monitoring), this folder contains the installation instructions for installing these using **Docker Compose**.

## Prerequisites

Before we can create our `monitoring stack` on our `docker` **Proxmox LXC**. We must have finished these steps:

- [`docker`](../README.md)
- [`networkstack`](../networkstack/README.md)

## Installation

1. Go to your users `home` directory and go to your dedicated docker directory and create a new directory for `monitoringstack`:
    ```
    cd ~
    cd docker
    mkdir -p monitoringstack
    cd monitoringstack
    ```

2. Retrieve the compose file and .env file:
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/monitoringstack/compose.yaml 
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/monitoringstack/.env
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

5. Change `GOTIFY_USERNAME` and `GOTIFY_PASSWORD` to a more username and password.

6. Now do the same for `SCRUTINY_DATABASE_USERNAME` and `SCRUTINY_DATABASE_PASSWORD`.

7. Set a more secure `SCRUTINY_DATABASE_TOKEN`. ([hint](https://randomkeygen.com/jwt-secret))

8. Now we need to install the service that actually tells our **Docker LXC** what state our disks are in. So, navigate to the **Proxmox Node**'s shell.

9. To install **Scrutiny** and its dependencies I have made a [script](scripts/install-scrutiny.sh).
    ```
    wget -qO- https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/monitoringstack/scripts/install-scrutiny.sh | bash -x
    ```

10. Now that we've intalled **Scrutiny** we need to setup the script and services that send the data to our **Docker LXC**. Create a folder to work in:
    ```
    mkdir -p /node/scripts
    cd /node/scripts
    ```

11. Now download the script that sends the data to our **Docker LXC**.
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/monitoringstack/scripts/scrutiny.sh
    ```

12. Open up the file and modify the `SCRUTINY_IP`:
    ```
    nano scrutiny.sh
    ```
    Change `192.168.xxx.xxx` to your **Docker LXC**'s ip.

13. Now make this script executable:
    ```
    chmod +x scrutiny.sh
    ```

14. To make this service run on start-up and on an interval I have created some systemd services. Download these using:
    ```
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/monitoringstack/services/scrutiny.service
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/monitoringstack/services/scrutiny.timer
    ```

15. Now enable these services using:
    ```
    systemctl daemon-reload
    systemctl enable scrutiny.timer
    systemctl start scrutiny.timer
    ```

16. Now we can head back to our **Proxmox LXC** and start the `monitoringstack`.
    ```
    cd ~/docker
    cd monitoringstack
    docker compose up -d
    ```

## Configuration

### Gotify 

**Gotify** doesn't require any more configuration.  
To access the dashboard go to port `8070` of the **Proxmox LXC**'s IP.  
You can login with the credentials set in the .env file.

### Diun

To configure **Diun** you need to follow these steps:

1. First we'll setup notifications. Go to the **Proxmox LXC**'s IP address on port `8070`.

2. Login with the `username` and `password` set in the .env for **Gotify**.

3. Go to `Apps` and **Create an Application**.

4. Copy the token.

5. Open the .env file:
    ```
    nano .env
    ```

6. Replace `DIUN_GOTIFY_TOKEN` with the token.

### Scrutiny

To configure **Scrutiny** you need to go to port `8082` of the ip address of the **Proxmox LXC**.

1. First we'll setup notifications. Go to the **Proxmox LXC**'s IP address on port `8070`.

2. Login with the `username` and `password` set in the .env for **Gotify**.

3. Go to `Apps` and **Create an Application**.

4. Copy the token.

5. Open the .env file:
    ```
    nano .env
    ```

6. Replace `SCRUTINY_GOTIFY_TOKEN` with the token.

## Start on boot-up

To make this stack start on the boot-up of the LXC follow [these instructions](../BOOT-UP.md#adding-a-stack).

## Debugging

If you have any issues setting up `monitoringstack` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Docker](https://www.docker.com/) - Hardware accelerated containers
- [Scrutiny](https://github.com/AnalogJ/scrutiny) - Disk monitoring 
