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

3. Go the device's **Hardware** tab on your **Proxmox VM**. And hit add **PCI Device**.

4. Select your device and check **All functions**.
