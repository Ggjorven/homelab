# OPNSense

**OPNSense** is a router and firewall operating system, this branch contains the installation instructions for installing **OPNSense** as a **Proxmox VM**.

## Prerequisites

Before we can create the **OPNSense VM** we need to have completed these steps:

- [`Enable IOMMU`](./../../tutorials/proxmox/ENABLE-IOMMU.md)

## Steps

1. Before we can create a **VM** we need to download the latest **OPNSense** iso. Go to [the download page](https://opnsense.org/download/) and select **amd64**, **vga** and mirror location of your choosing.

2. Now right click the **Download OPNSense** button and **Copy Link**.

3. Navigate to the **Proxmox WebUI** on port `8006` on the IP you chose in the **Proxmox** installation.

4. Select the `local` storage pool under your **Proxmox Node**'s name (ex. `pve2`).

5. Navigate to **ISO Images** and click **Download from URL**. Now paste the copied url.

6. Click **Query URL**.

7. Before we hit **Download** we want to make sure that the image will be correct, so go back to the **OPNSense** download page and copy the checksum listed under **Checksum Verification** (ex. `d975ed876e0650f6a5bf30b2e97218c5eaa370bef6597b19f43e22c1b950d3fc`).

8. Now in **Proxmox** enable the advanced options in the bottom right of the box and set the **Hash Algorithm** to **SHA-256** as specified on [the download page](https://opnsense.org/download/) and paste your copied checksum.

9. Now hit **Download** and wait.

10. After the download has finished we can create our VM. Right click on your **Proxmox Node**'s name (ex. `pve2`) and select **Create VM**.

11. Give the **VM** a name like `opnsense`. Optionally enable **Start at boot**. **Next**! 

12. Under **ISO Image** select your recently downloaded **OPNSense** image. **Next**!.

13. Under **System** just keep all default except enable **Qemu Agent**. **Next**!

14. Under **Disks** things get a little more complicated. For **Bus/Device** select **SCSI**. 

15. For **Cache Mode** select **Write Back**. Also enable **Discard**.

16. Select an appropriate size for the disk (ex. `32` GiB). **Next**!

17. For **CPU** select a reasonable amount of cores (**OPNSense** doesn't use much), so `1` or `2`. I use `2`. **Next**!

18. For the memory give 8GB so `8192` MiB. **Next**!

19. Under **Network** enable **No network device**. **Next!**.

20. Confirm all your settings are correct. If that's the hit **Finish** and optionally enable **Start after created**.

21. TODO

## Configuring

// TODO: ...

## Debugging

If you have any issues setting up `home-assistant` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [OPNSense](https://docs.opnsense.org/manual/install.html) - OPNSense install guide
