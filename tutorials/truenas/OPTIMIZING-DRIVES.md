# Optimizing drives for NAS usage

This file contains the steps for optimizing consumer drives for **NAS** usage.

## Prerequisites

Before we can start installing software we must have finished these tutorials:

- [`root ssh access`](./ROOT-SSH-ACCESS.md)
- [`ability to install apt software`](./INSTALLING-APT-SOFTWARE.md) (keep the terminal open for these steps)

## Steps

With the terminal open from the [`ability to install apt software`](./INSTALLING-APT-SOFTWARE.md) follow these steps:

1. First we'll find out the types of drives that are in the system:
    ```sh
    lsblk -o NAME,SIZE,TYPE,MODEL,SERIAL,FSTYPE,MOUNTPOINTS
    ```

2. You can identify Western Digital drives by the model name starting with "WDC". Seagate drives often start with "ST". If it's something else please google or ask an LLM.

3. Now follow the the steps below per drive type. (Ignore the QEMU HARDDISK)

### Western Digital

1. Consumer Western Digital drives often have **IntelliPark**, which parks the harddrive head every X seconds, but ZFS writes a lot of metadata files making the head constantly park and unpark, making the lifetime of the drive significantly shorter.

2. To check the drive and disable or enable it install `idle3ctl`:
    ```
    apt update && apt install idle3-tools
    ```

3. Before doing anything check if it's even enabled on the drive (ex. `/dev/sdb`) by running:
    ```
    idle3ctl -g /dev/sdb
    ```
    It can show a time of like `80` which means park every `8` seconds or it can already show disabled.

4. If it's not already disabled disable it with:
    ```
    idle3ctl -d /dev/sdb
    ```

5. Check it's actually disabled now:
    ```
    idle3ctl -g /dev/sdb
    ```

6. Now fully shutdown your system (the full **Proxmox Node**) and power cycle it so the drive can configure the new settings, so not just a reboot.

### Other

I don't have any optimization tips for other drive types, but contributions are highly appreciated.
