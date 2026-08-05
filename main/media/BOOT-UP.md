# BOOT-UP

To make our **Docker Stacks** start on boot-up of `docker` I have created a **systemd** service.  
This file contains the installation instructions.

## Installation

> [!NOTE]
> The following instructions only have to be executed once, so probably at your first stack. (ex. `networkstack`)

### Boot

To allow us to easily add stacks to start a boot-up of the `docker` LXC install this script and **systemd** service.

1. First make sure we have a folder for our script:
    ```
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    ```

2. Now download my compose-boot script:
    ```
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/scripts/compose-boot.sh
    sudo chmod +x compose-boot.sh
    ```

3. Now set the `USERNAME` variable to your linux user's username:
    ```
    sudo nano compose-boot.sh
    ```

4. Now download the accompanying **systemd** service:
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

### Shutdown

To allow us to easily add stacks to gracefully shutdown at the shutdown of the `docker` LXC install this script and **systemd** service.

1. First make sure we have a folder for our script:
    ```
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    ```

2. Now download my compose-shutdown script:
    ```
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/scripts/compose-shutdown.sh
    sudo chmod +x compose-shutdown.sh
    ```

3. Now set the `USERNAME` variable to your linux user's username:
    ```
    sudo nano compose-shutdown.sh
    ```

4. Now download the accompanying **systemd** service:
    ```
    cd /etc/systemd/system
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/services/compose-shutdown.service
    ```

5. Modify the **systemd** service:
    ```
    sudo nano compose-shutdown.service
    ```
    And change `User` and `Group` to reflect your linux user's username:
    ```
    User=<username>
    Group=<username>
    ```

6. Now enable this service:
    ```
    sudo systemctl daemon-reload
    sudo systemctl enable compose-shutdown
    ```
