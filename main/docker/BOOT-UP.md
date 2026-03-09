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

3. Now download the accompanying **systemd** service:
    ```
    cd /etc/systemd/system
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/services/compose-boot.service
    ```

4. Modify the **systemd** service:
    ```
    sudo nano compose-boot.service
    ```
    And change `User` and `Group` to reflect your linux user's username:
    ```
    User=<username>
    Group=<username>
    ```

5. Now enable this service:
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

3. Now download the accompanying **systemd** service:
    ```
    cd /etc/systemd/system
    sudo wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/docker/services/compose-shutdown.service
    ```

4. Modify the **systemd** service:
    ```
    sudo nano compose-shutdown.service
    ```
    And change `User` and `Group` to reflect your linux user's username:
    ```
    User=<username>
    Group=<username>
    ```

5. Now enable this service:
    ```
    sudo systemctl daemon-reload
    sudo systemctl enable compose-shutdown
    ```

## Adding a stack

### Boot

To add a new stack to start on boot-up of the `docker` LXC modify the script installed above.

1. Open up the compose-boot script:
    ```
    sudo nano compose-boot.sh
    ```

2. Uncomment the lines for your stack, example:
    ```
    # Compose boot up 1 (networkstack)
    # cd /home/<username>/docker/networkstack
    # docker compose up -d
    ```
    To:
    ```
    # Compose boot up 1 (networkstack)
    cd /home/<username>/docker/networkstack
    docker compose up -d
    ```

3. Change `<username>` to the user you created for `docker`.

### Shutdown

To add a new stack to the graceful shutdown of the `docker` LXC modify the script installed above.

1. Open up the compose-shutdown script:
    ```
    sudo nano compose-shutdown.sh
    ```

2. Uncomment the lines for your stack, example:
    ```
    # Compose boot up 2 (monitoringstack)
    # cd /home/<username>/docker/monitoringstack
    # docker compose down
    ```
    To:
    ```
    # Compose boot up 2 (monitoringstack)
    cd /home/<username>/docker/monitoringstack
    docker compose down
    ```

3. Change `<username>` to the user you created for `docker`.
