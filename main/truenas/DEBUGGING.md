# Debugging

This file exists with the purpose of helping you debug your issues with `omv`. This is not a foolproof file, it may miss certain issues and steps.

## Debugging steps

To debug any issues with `omv` use the following steps:

1. // TODO: ...

## Issues

### Disk Failure

It can be very annoying when a disk fails. Since we are virtualizing disks based on actual disks with `qemu` the **Open Media Vault** **VM** will fail. To resolve this you'll want to follow these steps to replace the disk and rebuild the RAID array.

1. Navigate to the **Proxmox Node**'s shell and check all available disks:
    ```
    lsblk |awk 'NR==1{print $0" DEVICE-ID(S)"}NR>1{dev=$1;printf $0" ";system("find /dev/disk/by-id -lname \"*"dev"\" -printf \" %p\"");print "";}'|grep -v -E 'part|lvm' 
    ```

2. Take note of all the disks still available. Now check which `scsiX` corresponds with this in the config file:
    ```
    cat /etc/pve/qemu-server/<VMID>.conf
    ```

3. We'll need to remove this virtual disk to be able to boot into the **VM** again.
    ```
    qm set <VMID> --delete <scsi ID> 
    ```
    Example:
    ```
    qm set 200 --delete scsi1
    ```

4. We can now start the **VM** again.

5. Go to the **VM**'s shell. And login.

6. Now we need to check our RAID status:
    ```
    cat /proc/mdstat
    ```
    It should show `degraded` and 2 out of the 3 `U`'s like `[_UU]`. The order may vary.

7. The above status means we can fully recover all of our data. Shutdown the **VM** and the **Proxmox Node**.

8. Now physically replace the disk with a new one.

9. Restart the machine.

10. Now follow the [Disk passthrough](../../tutorials/proxmox/DISK-PASSTHROUGH.md) steps again and use the same `scsiX` that is now missing.

11. Now start the **Open Media Vault** **VM** again. And login again.

12. Identify your new disk (look for the one with no partition table / unformatted):
    ```
    lsblk
    fdisk -l
    ```

13. (Optional but recommended) Wipe the partition table:
    ```
    wipefs -a /dev/sdX 
    ```

14. Add the new disk to the RAID array, replace `/dev/sdX` with your actual disk name:
    ```
    mdadm /dev/md0 --add /dev/sdX
    ```
    Example:
    ```
    mdadm /dev/md0 --add /dev/sdc
    ```

15. Monitor the rebuild, this can take a varying amount of time based on the size of your disks:
    ```
    watch cat /proc/mdstat
    ```

## Helping others

If you have found more issues while following the steps and figured it out please create a pull request with your issue and it's debugging steps and resolution.
