# Installing APT software in TrueNAS

This file contains the steps for installing software using `apt` in **TrueNAS**.  

## Prerequisites

Before we can start installing software we must have finished these tutorials:

- [`root ssh access`](./ROOT-SSH-ACCESS.md)

## Steps

1. First navigate to the **TrueNAS** WebUI and login as an admin user.

2. Go to **System** -> **Services**.

3. If **SSH** is "Stopped" press the start button next to the "Stopped" status (not the **Start Automatically** switch).

4. Open a terminal on your machine and **SSH** into the TrueNAS server by running:
    ```sh
    ssh root@<TRUENAS-IP>
    ```
    Replace `<TRUENAS-IP>` with the actual IP.  
    Also enter your passphrase for your ssh key if it asks.

5. The easiest way I have found to install software is by first installing dev tools like so:
    ```sh
    install-dev-tools
    ```

6. After that has completed the `root` user will be able to install software using `apt`.

7. Be careful and don't brick your installation :)
