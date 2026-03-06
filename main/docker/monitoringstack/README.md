# Monitoring Stack

**Monitoring Stack** is a collection of monitoring related services, this folder contains the installation instructions for installing these using **Docker Compose**.

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

5. Modify the `username` and `password` to something more secure.

6. Set a more secure `SCRUTINY_DATABASE_TOKEN`. ([hint](https://randomkeygen.com/jwt-secret))

7. Now we need to install the service that actually tells our **Docker LXC** what state our disks are in. So, navigate to the **Proxmox Node**'s shell.

8. To install **Scrutiny** and its dependencies I have made a [script](scripts/install-scrutiny.sh).
    ```
    wget -qO- https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/monitoringstack/scripts/install-scrutiny.sh | bash -x
    ```

9. Now that we've intalled **Scrutiny** we need to setup the script and services that send the data to our **Docker LXC**. Create a folder to work in:
    ```
    mkdir -p /node/scripts
    cd /node/scripts
    ```

10. Now download the script that sends the data to our **Docker LXC**.
    ```
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/monitoringstack/scripts/scrutiny.sh
    ```

11. Open up the file and modify the `SCRUTINY_IP`:
    ```
    nano scrutiny.sh
    ```
    Change `192.168.xxx.xxx` to your **Docker LXC**'s ip.

12. Now make this script executable:
    ```
    chmod +x scrutiny.sh
    ```

13. To make this service run on start-up and on an interval I have created some systemd services. Download these using:
    ```
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/monitoringstack/services/scrutiny.service
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/monitoringstack/services/scrutiny-timer.timer
    ```

14. Now enable these services using:
    ```
    systemctl daemon-reload
    systemctl enable scrutiny-timer.timer
    systemctl start scrutiny-timer.timer
    ```

15. Now we can head back to our **Proxmox LXC** and start the `monitoringstack`.
    ```
    cd ~/docker
    cd monitoringstack
    docker compose up -d
    ```

## Configuration

### Scrutiny

**Scrutiny** doesn't require any more configuration after setting up the `monitoringstack`.

## Start on boot-up

To make `networkstack` start-up on boot we can set up a **systemd** service. I have created a compose-boot service for this purpose.  

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
    cd /home/<username>/docker/monitoringstack
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

If you have any issues setting up `networkstack` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Docker](https://www.docker.com/) - Hardware accelerated containers
- [Scrutiny](https://github.com/AnalogJ/scrutiny) - Disk monitoring 
