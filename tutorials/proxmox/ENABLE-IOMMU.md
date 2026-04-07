# Enabling IOMMU in Proxmox

This file contains the steps for enabling **IOMMU** in **Proxmox**.
These steps have been taken from this [thread](https://www.reddit.com/r/Proxmox/comments/1brl7vw/guide_how_to_enable_iommu_for_pci_passthrough/) and slightly modified.

## Steps

1. On your **Proxmox Node** edit the grub file `/etc/default/grub`:
    ```
    nano /etc/default/grub 
    ```
    And change `GRUB_CMDLINE_LINUX_DEFAULT` to this line exactly:
    ```
    GRUB_CMDLINE_LINUX_DEFAULT="quiet amd_iommu=on"
    ```
    Or replace `amd_iommu` with `intel_iommu` if you have an intel CPU.

2. Update grub:
    ```
    update-grub
    ```

3. Reboot your **Proxmox Node**.

4. Verify it's enabled with:
    ```
    dmesg | grep -e DMAR -e IOMMU
    ```
    You should see something like:
    ```
    DMAR: IOMMU enabled
    ```
