# misc

`misc` is a **Proxmox LXC** on the **Proxmox Node** with **docker** and **docker compose** installed.  
This folder contains the installation instructions and configuration files used for this device.

## Steps

1. From the **Proxmox** WebUI navigate to the **Node**'s **Shell**.

2. Start creation of a **Docker LXC** using the [community script](https://community-scripts.org/scripts/docker):
    ```sh
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
    ```

3. Choose `Advanced Install`. 

4. Choose **Unprivileged**, set a safe root password, set the container ID to `116` (matches with the VLAN) and set the hostname to `misc` (or something else).

5. For the `misc` LXC I have given it a disk of **32GB**, **2vCPU**s and **2048MiB** of RAM.

6. For the (primary) **Network Bridge** select `vmbr1` and set a static IP (since we don't have a DHCP server). Set the IP to `172.20.116.10/24` and the gateway to `172.20.116.1`. For IPv6 select `none`.

7. Leave **MTU Size** blank, same for **DNS search domain**, **DNS server IP** and **MAC-address**.

8. Set the **VLAN tag** to `116` to get the proper firewall rules.

9. You can keep the **Tags** as default or set it to something custom like: `docker;misc`.

10. Provision the SSH for root by using the `found` option (or provide your own). Use space to select the key. And enable `root` SSH access.

11. Leave **FUSE support** disabled, same for **TUN/TAP** support.

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

26. We also want the **LXC** to boot properly on startup, go to **Options** tab and set **Start/Shutdown order** to `15`. 

27. Reboot the **LXC** to apply the changes.

28. Now go to **LXC**'s **Shell** and login with `root` and the password you set in the installation.

29. Create the `misc` group and user in the LXC using:
    ```sh
    groupadd -g 1000 misc
    useradd -u 1000 -g 1000 -m -s /bin/bash misc
    usermod -aG docker misc
    usermod -aG sudo misc
    ```

30. Set a (safe) password for the `misc` user:
    ```sh
    passwd misc
    ```

31. Now login as the `misc` user:
    ```sh
    su misc
    ```

32. Now we're going to install all of the files. Start by navigating to the `home` directory:
    ```sh
    cd ~/
    ```

33. Get the global .env:
    ```sh
    BRANCH=main
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/.env"
    ```

34. Create the `networking` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/networking
    cd ~/networking
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/networking/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/networking/compose.yaml"
    ```

35. Create the `monitoring` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/monitoring
    cd ~/monitoring
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/monitoring/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/monitoring/compose.yaml"
    ```

36. Create the `memos` stack:
    ```sh
    BRANCH=main
    mkdir -p ~/memos
    cd ~/memos
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/memos/.env"
    wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/memos/compose.yaml"
    ```

37. Get the `up` and `down` scripts:
    ```sh
    BRANCH=main
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/up-networking.sh"
    sudo chmod +x up-networking.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/up-monitoring.sh"
    sudo chmod +x up-monitoring.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/up-memos.sh"
    sudo chmod +x up-memos.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/down-networking.sh"
    sudo chmod +x down-networking.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/down-monitoring.sh"
    sudo chmod +x down-monitoring.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/down-memos.sh"
    sudo chmod +x down-memos.sh
    ```

38. Also get the `compose-boot`, `compose-shutdown` and `compose-restart` scripts and services:
    ```sh
    BRANCH=main
    sudo mkdir -p /lxc/scripts
    cd /lxc/scripts
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/compose-boot.sh"
    sudo chmod +x compose-boot.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/compose-shutdown.sh"
    sudo chmod +x compose-shutdown.sh
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/scripts/compose-restart.sh"
    sudo chmod +x compose-restart.sh
    cd /etc/systemd/system
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/services/compose-boot.service"
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/main/misc/services/compose-shutdown.service"
    ```

39. Enable the `systemctl` for `compose-boot` and `compose-shutdown`:
    ```sh
    sudo systemctl daemon-reload
    sudo systemctl enable compose-boot
    sudo systemctl enable compose-shutdown
    ```

40. Now start the `networking` and `monitoring` stacks:
    ```sh
    sudo /lxc/scripts/up-networking.sh
    sudo /lxc/scripts/up-monitoring.sh
    ```
    You can now start configuring individual stacks listed below.

## Configuration

### Memos

**Memos** doesn't require any configuring via the `.env` file.  
So just start the container:
```sh
sudo /lxc/scripts/up-memos.sh
```

Now that the container is running we'll start configuring via the WebUI on port `5230`. This requires either having `vmbr0` still attached or having set up [`priv-net`](./../priv-net/README.md).

1. TODO

## Debugging

If you have any issues setting up `misc` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

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
