# TrueNAS

TrueNAS is a NAS operating system run as a **Proxmox VM**, this branch contains the steps to easily redeploy a TrueNAS setup with an SMB network share.

## Installation

1. Create a **Proxmox VM** with the [truenas iso image](https://www.truenas.com/download-truenas-community-edition/).

2. Pass through all the disks following these steps (taken from [wiki](https://pve.proxmox.com/wiki/Passthrough_Physical_Disk_to_Virtual_Machine_(VM)))::  
    
    1. List all disks on the **Proxmox Node** using the following command:
        ```
        lsblk |awk 'NR==1{print $0" DEVICE-ID(S)"}NR>1{dev=$1;printf $0" ";system("find /dev/disk/by-id -lname \"*"dev"\" -printf \" %p\"");print "";}'|grep -v -E 'part|lvm' 
        ```

    2. Take note of the path of the desired disk (example: `/dev/disk/by-id/ata-WDC_XXXXXXX_WD-XXXXXXXXXX`)

    3. Go to the Proxmox VM's **Hardware** page, take note of the latest already created (virtual) hard disk id. (example: `scsi0`)

    4. Pass your physical disk to the VM from the Node's shell using:
        ```
        qm set <VMID> -<LATEST DISKID + 1> /dev/disk/by-id/ata-WDC_XXXXXXX_WD-XXXXXXXXXX
        ```

        example: 

        ```
        qm set 101 -scsi1 /dev/disk/by-id/ata-WDC_XXXXXXX_WD-XXXXXXXXXX
        ```

    5. Finally we need to add the serial number to the disk by modifying the VMID configuration file. The file is located in `/etc/pve/qemu-server/<VMID>.conf`. To open the file use the following command:
        ```
        nano /etc/pve/qemu-server/<VMID>.conf
        ```

    example:
        ```
        nano /etc/pve/qemu-server/101.conf
        ```

    6. Now add `,serial=XXXXXXXXX` to the relevant disk named `scsiX` where the serial number is the final part of the ata disk path we got from step 2 in our example `WD-XXXXXXXXXX`.
        ```
        scsi1: /dev/disk/by-id/ata-WDCXXXXXXX-XXXXXX_WD-XXXXXXXX,backup=0,size=12345678910K,serial=WD-XXXXXXXXXX
        ```

3. Create a pool in TrueNAS using the disks and the desired data layout.

4. Now create a **Dataset** of type **SMB** with that pool.

5. Create users and groups under **Credentials** as desired.

6. Add these groups and users to the **Permissions** of the **Dataset**.

7. Enjoy! (If you can't find it under **Network** type in the **IP** manually)

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [TrueNAS](https://www.truenas.com/) - NAS Operating System
