# Add Clipboard functionality to NoVNC

This file contains the steps for being able to use your clipboard in a **Proxmox VM**.
These steps have been taken from this [thread](https://forum.proxmox.com/threads/tl-dr-for-getting-novnc-copy-paste-clipboard-sharing-working-with-ubuntu-24-guest.159051/) and slightly modified.

## Steps

1. On the **Proxmox VM**, install: 
    ```
    sudo apt install -y qemu-guest-agent spice-vdagent
    ```

2. On the **Proxmox Node** run:
    ```
    qm set <VMID> -vga clipboard=vnc
    ```
    where `<VMID>` is your virtual machine's proxmox id.

3. Reboot your **Proxmox VM** to enable the clipboard button in the **NoVNC** screen.
