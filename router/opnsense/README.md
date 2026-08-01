# OPNSense

**OPNSense** is a router and firewall operating system, this branch contains the installation instructions for installing **OPNSense** as a **Proxmox VM**.

## Prerequisites

Before we can create the **OPNSense VM** we need to have completed these steps:

- [`Enable IOMMU`](./../../tutorials/proxmox/ENABLE-IOMMU.md)

## Steps

1. Before we can create a **VM** we need to download the latest **OPNSense** iso. Go to [the download page](https://opnsense.org/download/) and select **amd64**, **dvd** and mirror location of your choosing.

2. Now right click the **Download OPNSense** button and **Copy Link**.

3. Navigate to the **Proxmox WebUI** on port `8006` on the IP you chose in the **Proxmox** installation.

4. Select the `local` storage pool under your **Proxmox Node**'s name (ex. `pve2`).

5. Navigate to **ISO Images** and click **Download from URL**. Now paste the copied url.

6. Click **Query URL**.

7. Before we hit **Download** we want to make sure that the image will be correct, so go back to the **OPNSense** download page and copy the checksum listed under **Checksum Verification** (ex. `95cafedda6d5b22ce832e249dc2309110fbee19f813ad78cf28bb3d387186bfb`).

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

20. Confirm all your settings are correct. If that's the hit **Finish**.

21. Navigate to **VM** under the **Proxmox Node** (ex. `pve2`).

22. Go to the **Hardware** tab and click **Add** and select **PCI Device**.

23. Select **Raw Device**. Select 1 of your NICs, but NOT YOUR MANAGEMENT NIC!

24. The device name should look something like: "Ethernet Controller I226-V".

25. Enable **All Functions** and **Add**!

26. Now do the same for your other NIC (This will be our WAN and LAN ports).

27. Before we can install and configure **OPNSense** we need to make sure that our host never attaches the NICs to the host, so we'll need to disable the appropriate drivers.

28. To find out what drivers your NICs are using run:
    ```sh
    lspci -k | grep -A3 -i ethernet
    ```
    Take note of the output like:
    ```
    Kernel driver in use: igc
    ```
    Where in this case `igc` is the driver. Some common examples are: `igc`, `e1000e` or `e1000e`.

29. Now disable this driver by create a blacklist file like `/etc/modprobe.d/blacklist-igc.conf`:
    ```sh
    nano /etc/modprobe.d/blacklist-igc.conf
    ```
    and paste:
    ```
    blacklist igc
    ```
    Replace `igc` with your actual driver name.

30. Now we'll want to make the NICs run **VFIO** drivers. First get the [`vendor`:`deviceid`] for your NICs:
    ```sh
    lspci -nn | grep -i ethernet
    ```
    You'll get lines like:
    ```
    01:00.0 Ethernet controller [0200]: Intel Corporation Ethernet Controller I226-V [8086:125c] (rev 04)
    ```
    Where `8086:125c` is the `vendor`:`deviceid`. Take note of these!

31. Now edit `/etc/modprobe.d/vfio.conf` and add the `vendor`:`deviceid` to the `vfio-pci` devices:
    ```sh
    nano /etc/modprobe.d/vfio.conf
    ```
    Add or modify the line:
    ```
    options vfio-pci ids=8086:125c
    ```
    If you have multiple different IDs you can comma seperate them like so: `8086:125c,8086:15bc`.

32. Now we need to make sure we have the vfio modules enabled in `/etc/modules-load.d/vfio.conf`.
    ```sh
    nano /etc/modules-load.d/vfio.conf
    ```
    Add the lines:
    ```
    vfio
    vfio_iommu_type1
    vfio_pci
    vfio_virqfd
    ```

33. Now update `initram-fs` and reboot!
    ```
    update-initramfs -u -k all
    reboot
    ```

34. After the reboot check that the NICs are using the `vfio-pci` driver by re-running:
    ```sh
    lspci -k | grep -A3 -i ethernet
    ```

35. Now we'll start actually installing **OPNSense**. Go to the **Console** tab of the **VM** and click **Start Now** (in case the VM is already started this is not needed).

36. Wait for all the default installation instructions until you get to a `login` screen in the terminal.

37. Type `installer` as the username and `opnsense` as the password. 

38. You'll now be greated by a keymap selection screen. Select the default or the one you prefer.

39. Now select **Install (ZFS)**.

40. Select **stripe**. (I know no redundancy :o)

41. Now select the QEMU HARDDISK and after selecting confirm with Yes and wait...

42. Now change your root password to something more secure and **Complete Install**!

43. Select **Halt now**.

44. Now navigate back to the **Hardware** tab of the **VM** and click on the **CD/DVD Drive** and hit **Remove**.

45. Now go back to the **Console** and start it again.

46. Again wait for the autoboot and login as `root` and with the password you just set.

47. Now you'll be greeted with a menu of options to select. First we'll set which port is LAN and which is WAN. Type option `1` (Assign interfaces).

48. You'll be asked if you want to configure LAGGs and VLANs, select `N` for both.

49. Now select the WAN interface by auto-detecting (`a`). Then plug in an ethernet cable to the port you wish to be WAN (make sure the ethernet cable is connected). Then press enter.

50. Do the same for LAN.

51. Then for the optional interface just enter nothing and hit enter again.

52. Confirm your changes by selecting `y`.

53. Now to access the WebUI things get a little more complicated (and annoying). Plug your ethernet cable into the LAN port of your newly created router and plug the other end into your PC or laptop for configuration through the WebUI.

54. Navigate to `https://192.168.1.1` on your device plugged into the router.

55. Login with `root` and your password.

56. One of the first things I like to do is go to **System** -> **Settings** -> **General** and under **Theme** select `opnsense-dark`. Scroll to the bottom and hit **Save**.

57. Now we're gonna follow the setup wizard under **System** -> **Configuration** -> **Wizard**. Hit **Next**.

58. I like to switch the **Domain** from `.internal` to `.lan`, since I also use that for my proxmox domain.

59. Set the timezone to `Europe/Amsterdam` or whatever timezone you're in.

60. For the DNS servers I like to start with `1.1.1.1` and `8.8.8.8`. Hit **Next**.

61. Keep the **Network [WAN]** default for now and hit **Next**.

62. Now for **Network [LAN]** we're gonna want to change the subnet from `192.168.1.1/24` to `10.10.1.1/24` (personal preference). Hit **Next**.

63. And for **Deployment Type** keep the defaults and hit **Next**.

64. Now again set your password (I know annoying) and click **Apply**.

65. Now because we have changed the DHCP range for the LAN we'll need to give our PC or laptop a new IP address. The easiest way is to unplug and replug the network cable.

66. Now navigate to `https://10.10.1.1`.

67. Before we continue, now plug an ethernet cable connected to your current internet into the WAN port, because we're gonna update our system.

68. Navigate to **System** -> **Firmware** -> **Status** and **Check for updates**. Close the release notes and hit **Update**. (Note: Sometimes this will restart your system)

69. After you have installed all the updates we can get into configuring or set up other services on this device like:
    - [`pihole`](./../pihole/README.md)

## Configuring

### DNS

To make the entire network use [pihole](./../pihole/README.md) we can configure certain DNS settings, follow these steps:

1. TODO

## Debugging

If you have any issues setting up `opnsense` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [OPNSense](https://docs.opnsense.org/manual/install.html) - OPNSense install guide
