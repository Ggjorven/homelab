# PCI(e) passthrough in Proxmox

This file contains the steps for passing through a PCIe device to a **Proxmox VM**.
These steps have been taken from this [wiki](https://pve.proxmox.com/wiki/PCI_Passthrough) and slightly modified.

## Steps

1. Verify IOMMU is enabled:
    ```
    dmesg | grep iommu
    ```
    If you don't see something like:
    ```
    DMAR: IOMMU enabled
    ```
    or
    ```
    [    0.642829] iommu: Default domain type: Translated
    [    0.642829] iommu: DMA domain TLB invalidation policy: lazy mode
    ```
    Follow [these steps](ENABLE-IOMMU.md).

2. Verify IOMMU isolation with:
    ```
    pvesh get /nodes/<NODENAME>/hardware/pci --pci-class-blacklist ""
    ```
    Where you replace `<NODENAME>` with the name of your **Proxmox Node**.  
    You should see something like:
    ```
    ┌──────────┬────────┬──────────────┬────────────┬────────┬───────────────────────────────────────────────────────────────────┬...
    │ class    │ device │ id           │ iommugroup │ vendor │ device_name                                                       │
    ╞══════════╪════════╪══════════════╪════════════╪════════╪═══════════════════════════════════════════════════════════════════╪
    │ 0x010601 │ 0xa282 │ 0000:00:17.0 │          5 │ 0x8086 │ 200 Series PCH SATA controller [AHCI mode]                        │
    ├──────────┼────────┼──────────────┼────────────┼────────┼───────────────────────────────────────────────────────────────────┼
    │ 0x010802 │ 0xa808 │ 0000:02:00.0 │         12 │ 0x144d │ NVMe SSD Controller SM981/PM981/PM983                             │
    ├──────────┼────────┼──────────────┼────────────┼────────┼───────────────────────────────────────────────────────────────────┼
    │ 0x020000 │ 0x15b8 │ 0000:00:1f.6 │         11 │ 0x8086 │ Ethernet Connection (2) I219-V                                    │
    ├──────────┼────────┼──────────────┼────────────┼────────┼───────────────────────────────────────────────────────────────────┼
    │ 0x030000 │ 0x5912 │ 0000:00:02.0 │          2 │ 0x8086 │ HD Graphics 630                                                   │
    ├──────────┼────────┼──────────────┼────────────┼────────┼───────────────────────────────────────────────────────────────────┼
    │ 0x030000 │ 0x1d01 │ 0000:01:00.0 │          1 │ 0x10de │ GP108 [GeForce GT 1030]                                           │
    ├──────────┼────────┼──────────────┼────────────┼────────┼───────────────────────────────────────────────────────────────────┼
    .
    .
    .
    ```
    You should see that each device has a different `iommugroup`.  
    If you don't have dedicated IOMMU groups, you can try moving the card to another PCI(e) slot.  
    If that's not an option use the standard approach by editing `/etc/default/grub`:
    ```
    nano /etc/default/grub
    ```
    And add the `pcie_acs_override=downstream,multifunction` option to `GRUB_CMDLINE_LINUX_DEFAULT`.

3. Go to the **Hardware** tab for the **VM** and click **Add** and select **PCI Device**.

4. Select **Raw Device**. Select your PCI(e) device.

5. Enable **All Functions** and **Add**! // NOTE: If you have boot issues with your **VM** open **Advanced** and disable **ROM-bar**.

6. Before we can start the VM we need to make sure that our host never attaches the PCI(e) device to the host, so we'll need to disable the appropriate drivers.

7. To find out what drivers your device is using run:
    ```sh
    lspci -k
    ```
    Find your device in the list and take note of the output underneath like:
    ```
    Kernel driver in use: igc
    ```
    Where in this case `igc` is the driver.

8. Now disable this driver by create a blacklist file like `/etc/modprobe.d/blacklist-igc.conf`:
    ```sh
    nano /etc/modprobe.d/blacklist-igc.conf
    ```
    and paste:
    ```
    blacklist igc
    ```
    Replace `igc` with your actual driver name.

9. Now we'll want to make the PCI(e) device run the **VFIO** drivers. First get the [`vendor`:`deviceid`] for your device:
    ```sh
    lspci -nn
    ```
    You'll get lines like:
    ```
    01:00.0 Ethernet controller [0200]: Intel Corporation Ethernet Controller I226-V [8086:125c] (rev 04)
    ```
    Find your device. Here `8086:125c` is the `vendor`:`deviceid`. Take note of the relevant id for your device.

10. Now edit `/etc/modprobe.d/vfio.conf` and add the `vendor`:`deviceid` to the `vfio-pci` devices:
    ```sh
    nano /etc/modprobe.d/vfio.conf
    ```
    Add or modify the line:
    ```
    options vfio-pci ids=8086:125c
    ```
    If you have multiple different IDs you can comma seperate them like so: `8086:125c,8086:15bc`.

11. Now we need to make sure we have the vfio modules enabled in `/etc/modules-load.d/vfio.conf`. // NOTE: This only needs to be done once for multiple devices
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

12. Now update `initram-fs` and reboot!
    ```
    update-initramfs -u -k all
    reboot
    ```

13. After the reboot check that the PCI(e) device is using the `vfio-pci` driver by re-running:
    ```sh
    lspci -k
    ```

14. Your device is now successfully passed through to the **VM**.
