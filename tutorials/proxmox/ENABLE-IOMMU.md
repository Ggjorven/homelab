# Enabling IOMMU in Proxmox

This file contains the steps for enabling **IOMMU** in **Proxmox**.  
These steps have been taken from this [thread](https://www.reddit.com/r/Proxmox/comments/1brl7vw/guide_how_to_enable_iommu_for_pci_passthrough/) and slightly modified.

## Steps

1. On your **Proxmox Node** edit the grub file `/etc/default/grub`:
    ```sh
    nano /etc/default/grub 
    ```
    And change `GRUB_CMDLINE_LINUX_DEFAULT` to this line exactly:
    ```
    GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on"
    ```
    Or replace `amd_iommu` with `intel_iommu` if you have an intel CPU.

2. Update grub:
    ```sh
    update-grub
    ```

3. Reboot your **Proxmox Node**.

4. Verify IOMMU is enabled:
    ```sh
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

## (Optional) Enable IOMMU splitting

By default, the kernel groups PCIe devices into **IOMMU** groups based on how they are physically connected on the PCIe bus. When passing a device to a VM, **Proxmox** requires the entire IOMMU group to be passed through. This means if two devices share an IOMMU group, passing one to a VM removes both from the host.  
A common example is an HBA card and an M.2 NVMe SSD ending up in the same IOMMU group because they share a chipset PCIe switch. Passing the HBA to a TrueNAS VM would then cause the host to lose the NVMe drive instantly.

> [!WARNING]
> `pcie_acs_override` is technically a security weakening of IOMMU isolation, it forces devices into separate groups that the hardware wanted together.

1. On your **Proxmox Node** edit the grub file `/etc/default/grub`:
    ```sh
    nano /etc/default/grub 
    ```
    And edit:
    ```
    GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on"
    ```
    Add `iommu=pt pcie_acs_override=downstream,multifunction`:
    ```
    GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on iommu=pt pcie_acs_override=downstream,multifunction"
    ```
    Make sure you keep your original `amd_iommu` or `intel_iommu`.

2. Update grub:
    ```sh
    update-grub
    ```

3. Reboot your **Proxmox Node**.
