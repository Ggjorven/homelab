# TrueNAS

**TrueNAS** is a NAS operating system run as a **Proxmox VM**, this branch contains the steps to easily (re-)deploy **TrueNAS**.

## Prerequisites

Before we can install **TrueNAS**. We must have finished these steps:

- [`Enable IOMMU`](./../../tutorials/proxmox/ENABLE-IOMMU.md)

## Steps

1. Before we can create a **VM** we need to download the latest **TrueNAS** iso. Go to [the download page](https://www.truenas.com/download/) and navigate to the latest Community Edition image (non-beta).

2. Now right click the download button and **Copy Link**.

3. Navigate to the **Proxmox WebUI** on port `8006` on the IP you chose in the **Proxmox** installation.

4. Select the `local` storage pool under your **Proxmox Node**'s name (ex. `pve1`).

5. Navigate to **ISO Images** and click **Download from URL**. Now paste the copied url.

6. Click **Query URL** and then **Download**.

7. After the download has finished we can create our **VM**. Right click on your **Proxmox Node**'s name (ex. `pve1`) and select **Create VM**.

8. Give the **VM** a name like `truenas`. **Next**! 

9. Under **ISO Image** select your recently downloaded **TrueNAS** image. **Next**!.

10. Under **System** just keep all default except enable **Qemu Agent**. **Next**!

11. Under **Disks** things get a little more complicated. For **Bus/Device** select **SCSI**. 

12. For **Cache Mode** select **Write Back**. Also enable **Discard**.

13. Select an appropriate size for the disk (ex. `32` GiB). **Next**!

14. For **CPU** select a reasonable amount of cores, I use `4`. **Next**!

15. For the memory give 16GB so `16384` MiB. **Next**!

16. Under **Network** set **bridge** to `vmbr1`. Set the **VLAN Tag** to `100` and finally disable the built-in **firewall**. **Next**!

17. Confirm all your settings are correct. If that's the hit **Finish**.

18. Navigate to **VM** under the **Proxmox Node** (ex. `pve2`).

19. Now we'll pass through the HBA to the **VM**. Go to the **Hardware** tab and click **Add** and select **PCI Device**. // NOTE: These steps have been taken from [this tutorial](./../../tutorials/proxmox/PCIE-PASSTHROUGH.md) and modified to be specific to HBAs.

20. Select **Raw Device**. Select 1 your HBA.

21. The device name should look something like: "SASXXXX ..." and a vendor like "Broadcom / LSI".

22. Enable **All Functions** and enable the **Advanced** options too and disable **ROM-Bar**. **Add**!

23. Before we can install and configure **TrueNAS** we need to make sure that our host never attaches the HBA to the host, so we'll need to disable the appropriate drivers.

24. To find out what drivers your HBA is using run:
    ```sh
    lspci -k | grep -A3 -i "sas\|scsi\|raid"
    ```
    Take note of the output like:
    ```
    Kernel driver in use: mpt3sas
    ```
    Where in this case `mpt3sas` is the driver. Some common examples are: `mpt3sas`, `megaraid_sas`, or `lpfc`.

25. Now disable this driver by create a blacklist file like `/etc/modprobe.d/blacklist-igc.conf`:
    ```sh
    nano /etc/modprobe.d/blacklist-mpt3sas.conf
    ```
    and paste:
    ```
    blacklist mpt3sas
    ```
    Replace `mpt3sas` with your actual driver name.

26. Now we'll want to make our HBA run **VFIO** drivers. First get the [`vendor`:`deviceid`] for your HBA:
    ```sh
    lspci -nn | grep -i "sas\|scsi\|raid"
    ```
    You'll get lines like:
    ```
    05:00.0 Serial Attached SCSI controller [0107]: Broadcom / LSI SAS2008 [1000:0072] (rev 03)
    ```
    Where `1000:0072` is the `vendor`:`deviceid`. Take note of these!

27. Now edit `/etc/modprobe.d/vfio.conf` and add the `vendor`:`deviceid` to the `vfio-pci` devices:
    ```sh
    nano /etc/modprobe.d/vfio.conf
    ```
    Add or modify the line:
    ```
    options vfio-pci ids=1000:0072
    ```
    If you have multiple different IDs you can comma seperate them like so: `1000:0072,8086:125c`.

28. Now we need to make sure we have the vfio modules enabled in `/etc/modules-load.d/vfio.conf`.
    ```sh
    nano /etc/modules-load.d/vfio.conf
    ```
    Add the lines (if not already there):
    ```
    vfio
    vfio_iommu_type1
    vfio_pci
    vfio_virqfd
    ```

29. Now update `initram-fs` and reboot!
    ```sh
    update-initramfs -u -k all
    reboot
    ```

30. After the reboot check that the HBA is using the `vfio-pci` driver by re-running:
    ```sh
    lspci -k | grep -A3 -i "sas\|scsi\|raid"
    ```

31. For local access as well as access through proxmox we also need to add the `vmbr0` bridge. Go back to the **Hardware** tab of the **VM**.

32. Hit **Add** and select **Network Device**. Select `vmbr0` and disable the built-in **firewall**. **Add**!

33. Now we'll start actually installing **TrueNAS**. Go to the **Console** tab of the **VM** and click **Start Now**!

34. Wait for the installation window to show up and select **Install/Upgrade**.

35. Now select the **QEMU HARDDISK** as the destination media (with space) and proceed with the installation.

36. Now select **Administrative user** as the **Web UI Authentication Method** and set your password.

37. For **Legacy Boot**/**Allow EFI Boot** select **No**, since we are virtualizing with a legacy BIOS.

38. Now wait... When you see the "Installation Succeeded" screen don't hit **Ok** yet. First go to the **Hardware** tab and click on the **CD/DVD Drive** and hit **Remove**.

39. Go back to the **Console** and select **Ok** and **Reboot System**.

40. After you are back in select the option for the **Linux Shell** (`8`).

41. We'll be setting up networking over `vmbr1`, go back to the **Hardware** tab of the **VM**.

42. Look for the **Network Device** set to **bridge** `vmbr1` probably net0. Take note of the MAC-address shown after `virtio=`, it should look something like `XX:XX:XX:XX:XX:XX`.

43. Now go back to the **Console** and execute:
    ```sh
    ip link show
    ```

44. Now look through the links and find the link with:
    ```
    link/ether XX:XX:XX:XX:XX:XX .....
    ```
    Where `XX:XX:XX:XX:XX:XX` is the same as the MAC-address you took note of.

45. Under that same link look for `altname` like so:
    ```
    altname enp0s18
    ```
    Take note of this name.

46. Now we need to set up our IP address and gateway, since our `vmbr1` doesn't have a DHCP server. Open `/etc/network/interfaces`:
    ```sh
    nano /etc/network/interfaces
    ```

47. Write:
    ```
    auto enp0s18
    inet enp0s18 inet static
        address 172.20.100.10/24
        gateway 172.20.100.1
    ```
    Above the:
    ```
    source /etc/network/interfaces.d/*
    ```
    Line.  
    These correspond with the VLAN ID specified in [this table](./../README.md#Deployments) and the VLAN we have subsequently created on `vmbr1` on the **Proxmox Host**.

48. Now reboot:
    ```sh
    reboot now
    ```

49. After reboot enter the linux shell again (option `8`).

50. Check your IP address attached to `vmbr0`, so you can access the WebUI:
    ```sh
    ip a
    ```
    Look for a line like:
    ```
    inet 192.168.XXX.XXX
    ```
    Maybe under option `3` or like `ens19`.

51. Open the WebUI under that IP address in a browser.

52. Log in with username `truenas_admin` and the password you set in the installation.

53. Go to **Storage** and hit **Create Pool**.

54. Name it `tank` (or something else). **Next**!

55. For my drives I set a **Layout** of **RAIDZ2**. It should auto-fill with the proper disks, if not set them manually. **Next**!

56. Hit **Next** until you reach **Cache**, if you have an SSD (attached to your HBA) set it as your **Cache** drive for extra performance.

57. Then hit **Next** until you reach the **Review** and **Create Pool**.

58. Now go to **Datasets** and create these datasets (use the **Generic** preset):
    ```
    tank
    ├── cloud (storage for NextCloud and Paperless-ngx)
    ├── downloads (storage for *Arr stack)
    ├── media (storage for Movies, Series, etc.)
    ├── photos (storage for family photos)
    └── users
        ├── my_name (personal private storage for me, replace with your actual name)
        └── family_member_name (personal private storage for a family member, replace with actual name)
    ```

59. We only want dedicated users to be able to access these folders, so we'll now be setting up groups and credentials. Go to **Credentials** -> **Groups**.

60. Now create these groups (follow the table and leave the rest as defaults):
    | GID | Name | SMB Group |
    | --- | --- | --- |
    | 1001 | media | No |
    | 1002 | cloud | No |
    | 1003 | photos | No |
    | 1004 | downloader | No |
    | 3001 | my_name | Yes |
    | 3002 | family_member_name | Yes |
    | 100000 | unprivileged_lxc_root | No |

61. Now we'll create the corresponding users, go to **Credentials** -> **Users**.

62. Now create these users, when setting the **Group** disable **Create New Primary Group** and set the group as defined in the table (follow the table and leave the rest as defaults):
    | Name | SMB Access | Disable password | (Primary) Group | UID |
    | --- | --- | --- | --- | --- |
    | media | No | Yes | media | 1001 |
    | cloud | No | Yes | cloud | 1002 |
    | photos | No | Yes | photos | 1003 |
    | downloader | No | Yes | downloaders | 1004 |
    | my_name | Yes | No | my_name | 3001 |
    | family_member_name | Yes | No | family_member_name | 3002 |
    | unprivileged_lxc_root | No | Yes | unprivileged_lxc_root | 100000 |

63. Go back to **Datasets** and select `cloud` and hit **Edit** on **Permissions**.

64. Click **Set ACL** and select **Create a custom ACL**.

65. Set the **Access Control List** to this list:
    | Who | Read | Write | Execute (Traverse) | Default (Inherit) |
    | --- | --- | --- | --- | --- |
    | User Obj | Yes | Yes | Yes | No |
    | Group Obj | Yes | Yes | Yes | No |
    | Group - unprivileged_lxc_root | Yes | Yes | Yes | No |
    | Mask | Yes | Yes | Yes | No |
    | Other | No | No | No | No |
    | User Obj | Yes | Yes | Yes | Yes |
    | Group Obj | Yes | Yes | Yes | Yes |
    | Group - unprivileged_lxc_root | Yes | Yes | Yes | Yes |
    | Mask | Yes | Yes | Yes | Yes |
    | Other | No | No | No | Yes |

66. At the bottom select **Save As Preset** and name it something like `POSIX_OWNER_GROUP_AND_UNPRIVILED_ROOT`. Now we can re-use it.

67. Now for these datasets:
    - `cloud`
    - `downloads`
    - `media`
    - `photos`
    
    1. **Edit** the **Permissions** and use the just created preset for the ACL permissions.  
    2. Set the **Owner** and **Owner Group** to the user/group with the same name as the dataset and enable the **Apply owner (group)** checkmarks below the selection.  
    3. (Optional) If you already have files in the directories also set the **Apply Permissions Recursively**. Now you can **Save**.

68. For the dataset `users` click **Edit** under **Details**.

69. Enable **Advanced Options**, scroll to the bottom and set **ACL Type** to **SMB/NFSv4**. **Save**.

70. Now **Edit** the **Permissions** for the `users` dataset and **Set ACL**.

71. For each family_member (including you) add a rule with a **Group** set to that user's group. Set the **ACL Type** to **Allow** and permission to **Traverse**, also enable **Inherit** under **Flags**. **Save Access Control List**.

72. Now for each dataset under `users` **Edit** the **Permissions** and **Set ACL**. Set the **Owner** and **Owner Group** to the user/group with the same name as the dataset and enable the **Apply owner (group)** checkmarks below the selection.

73. (optional) If you already have files in the directories also set **Apply Directories Recursively** and **Save Access Control List**.

74. Now we'll enable **Network Services**. Go to **System** -> **Services** and flick the switch **Start Automatically** to **On** for both **SMB** and **NFS**.

75. Now go back to **Datasets** and follow the steps below for each listed dataset:
    - `cloud`
    - `downloads`
    - `media`
    - `photos`
    1. Under **Usage** **Create NFS Share**.
    2. Open **Advanced Options**.
    3. Set **Maproot User** & **Maproot Group** to the user/group with the same name as the dataset.
    4. Under **Security** enable **SYS**.
    5. Under **Hosts** add 1 host with IP: `172.20.100.1` (the proxmox host)
    5. **Save**!

76. Now follow the steps for these **Datasets**:
    - `my_name`
    - `family_member_name`
    1. Under **Usage** **Create SMB Share**.
    2. Open **Advanced Options**.
    3. Enable **Access Based Share Enumeration**.
    4. **Save**!

77. Most of the steps are now complete. Now we'll setup auto-mounting to the **Proxmox Host**. Go to the **Proxmox** WebUI and go to the **Node**'s **Shell**.

78. We have these internal shares: `cloud`, `downloads`, `media` and `photos`. First create all the mountpoints:
    ```sh
    mkdir -p /mnt/cloud
    mkdir -p /mnt/downloads
    mkdir -p /mnt/media
    mkdir -p /mnt/photos
    ```

79. I have created multiple auto-mount scripts, download them:
    ```sh
    mkdir -p /node/scripts
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/truenas/scripts/mount-cloud.sh
    chmod +x mount-cloud.sh
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/truenas/scripts/mount-downloads.sh
    chmod +x mount-downloads.sh
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/truenas/scripts/mount-media.sh
    chmod +x mount-media.sh
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/truenas/scripts/mount-photos.sh
    chmod +x mount-photos.sh
    ```
    Note: If you have a different path than `/mnt/tank/xxx`, you must edit the `SHARE_PATH` variable in the script.

80. Download the `systemctl` services:
    ```sh
    cd /etc/systemd/system
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/truenas/services/mount-cloud.service
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/truenas/services/mount-downloads.service
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/truenas/services/mount-media.service
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/main/main/truenas/services/mount-photos.service
    ```

81. Enable the services:
    ```sh
    systemctl daemon-reload
    systemctl enable mount-cloud
    systemctl enable mount-downloads
    systemctl enable mount-media
    systemctl enable mount-photos
    ```

82. (optional) Start the services right now:
    ```sh
    systemctl start mount-cloud
    systemctl start mount-downloads
    systemctl start mount-media
    systemctl start mount-photos
    ```

83. (optional) [Optimize your drives for NAS usage](./../../tutorials/truenas/OPTIMIZING-DRIVES.md)

84. (optional) In the **Proxmox** WebUI for the **VM** set **Protection** to **Yes** under the **Options** tab.

85. (optional) You can now follow optional [configuration steps](#Configuration) like.
    - [Scrutiny](#Scrutiny)
    - [Filebrowser Quantum](#Filebrowser-Quantum)

## Configuration

### Scrutiny

To be able to easily track the state of our drives and see S.M.A.R.T. data we'll be setting up **Scrutiny**.

1. In the **TrueNAS** WebUI navigate to **Apps**.

2. Search for "Scrutiny" and select the result.

3. Hit **Install**.

4. Scroll down to **Network Configuration** and under **InfluxDB Port** -> **Port Bind Mode** set the mode to **Expose port for inter-container communication**.

5. Now scroll down to the bottom and hit **Install**.

6. To navigate to the **WebUI** of **Scrutiny** go to **Apps** and select the just created **Scrutiny** app and under **Application Info** click the **WebUI** button.

### Filebrowser Quantum

To be able to traverse your files and edit them from a browser we'll be setting up **Quantum Filebrowser**.

1. Before we can install **Filebrowser Quantum** we'll be setting up a and **Group** that access certain datasets.

2. In the **TrueNAS** WebUI navigate to **Credentials** -> **Groups**.

3. **Add** a group and set the **GID** to `2001` and set the **Name** to `filebrowser`. **Save**!

4. Now we'll be setting permissions for the **Group** `filebrowser` in the **Datasets**. For each dataset below
    - `cloud`
    - `downloads`
    - `media`
    - `photos`
    Add the following permissions:

    | Who | Read | Write | Execute (Traverse) | Default (Inherit) |
    | --- | --- | --- | --- | --- |
    | Group - `filebrowser` | Yes | Yes | Yes | No |
    | Group - `filebrowser` | Yes | Yes | Yes | Yes |

    If there are already files or directories in the dataset also set **Apply Permissions Recursively**.

5. Now we'll be setting permissions for the **Group** `filebrowser` in the **Datasets**. For each dataset below
    - `users`
    - `my_name`
    - `family_member_name`
    Add the following permissions:

    | Who | ACL Type | Permissions | Inherit |
    | --- | --- | --- | --- |
    | Group - `filebrowser` | Basic | Traverse | Yes |

    If there are already files or directories in the dataset also set **Apply Permissions Recursively**.

6. Now we can actually install **Filebrowser Quantum**, navigate to **Apps**.

7. Search for "Filebrowser Quantum" and select the result.

8. Hit **Install**.

9. Under **FileBrowser Quantum Configuration** set an **Admin Password**.

10. Scroll down to **User and Group Configuration** and set the **Group ID** to `2001` (the `filebrowser` group).

11. Scroll further down to **Storage Configuration** and **Add** **Additional Storage**.

12. Set the **Type** to **Host Path**.

13. Set the the **Mount Path** to `/tank` or anything you like.

14. Set the **Host Path** to `/mnt/tank` or the actual pool path if you changed the name.

15. Scroll down and **Install**.

16. To navigate to the **WebUI** of **Filebrowser Quantum** go to **Apps** and select the just created **Filebrowser Quantum** app and under **Application Info** click the **WebUI** button.

## Debugging

If you have any issues setting up `truenas` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [TrueNAS](https://www.truenas.com/) - NAS Operating System
