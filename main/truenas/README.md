# TrueNAS

**TrueNAS** is a NAS operating system run as a **Proxmox VM**, this branch contains the steps to easily (re-)deploy **TrueNAS**.

## Prerequisites

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
    ```
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

34. a

### Clipboard functionality

To be able to paste your clipboards contents into the **NoVNC** instance we need to change some settings on the host and the VM, the instructions can be found [here](./../../tutorials/proxmox/NOVNC-CLIPBOARD.md).

## Debugging

If you have any issues setting up `truenas` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [TrueNAS](https://www.truenas.com/) - NAS Operating System
