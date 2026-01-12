# *Arr Stack

An *arr stack is collection of services that automate the management of personal media, this branch contains the instructions for installing all services on a **Proxmox VM** with **Docker**.
These instructions are heavily inspired by [this youtube video](https://www.youtube.com/watch?v=twJDyoj0tDc) and [this guide](https://wiki.servarr.com/docker-guide). For more details look at those instructions, since this is my personal setup.

## Preview

![preview image]()

## Installation

1. From the **Proxmox** Node's shell install a **Docker VM** as a **Proxmox VM** using the [community script](https://community-scripts.github.io/ProxmoxVE/scripts?id=docker-vm).

2. Now we need to pass through our network share where we will store the movies, series & more.. To start we need to install some dependencies:
    ```
    apt install cifs-utils smbclient
    ```

3. Now we need to store our credentials in `/root/.smbcred` so we can use them when mounting:
    ```
    nano /root/.smbcred
    ```
    And paste:
    ```
    username=<YOUR USERNAME FOR SMB>
    password=<YOUR PASSWORD FOR SMB>
    ```

4. To make the mount persistent we need to modify `/etc/fstab`:
    ```
    nano /etc/fstab
    ```
    And paste this (Replace the IP and SMB share name):
    ```
    //<IP ADDRESS>/<SHARENAME> /mnt/nas cifs credentials=/root/.smbcred,iocharset=utf8,uid=1000,gid=1000,vers=3.0
    ```

5. Before we can actually mount it we need to actually create the `/mnt/nas` folder.
    ```
    mkdir /mnt/nas
    ```
    Now we can mount:
    ```
    mount -a
    ```

6. 

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Docker](https://github.com/Ggjorven) - Container ecosystem
