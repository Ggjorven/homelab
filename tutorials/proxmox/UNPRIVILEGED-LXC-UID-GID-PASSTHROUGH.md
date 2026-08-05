# Unprivileged LXC UID/GID Passthrough

This file contains the steps for passing through specific UIDs and GIDs from the **Proxmox Host** to an **Unprivileged LXC**.  
This is useful for NFS shares or other scenarios where a specific UID/GID must match between the container and the host.  
By default, Proxmox shifts all UIDs/GIDs inside an unprivileged LXC by `+100000`.  
So container UID/GID `1001` becomes host UID/GID `101001`, which breaks NFS auth and shared storage.  

## Steps

1. Stop the **LXC** container you want to configure.

2. Go to the **Shell** on the **Proxmox Host**.

3. Start editing the **LXC**'s config:
    ```
    nano /etc/pve/lxc/<CTID>.conf
    ```
    Where you replace `<CTID>` with the ID of your **LXC** container.

3. Add the following `lxc.idmap` lines to punch through for example UID `1001`:
    ```
    # UIDs: default range 0-1000, passthrough 1001, resume 1002+
    lxc.idmap: u 0 100000 1001
    lxc.idmap: u 1001 1001 1
    lxc.idmap: u 1002 101002 64534
    ```
    The different options are numbers per line are: `<uid or gid> <container-id> <host-id> <count>`.  
    To get the lines for other IDs follow these steps:  
     
    1. The first line will be:
        ```
        lxc.idmap: <u or g> 0 100000 <ID>
        ```
        Where you replace the placeholders with the actual values.

    2. The second line will be:
        ```
        lxc.idmap: <u or g> <ID> <ID> 1
        ```
        Where you replace the placeholders with the actual values.

    3. The third line will be:
        ```
        lxc.idmap: <u or g> <ID+1> <100000+ID+1> <65535-ID>
        ```
        Where you replace the placeholders with the actual values.

4. Now grant the `root` user on the **Proxmox Host** permission to use those IDs by editing `/etc/subuid` or `/etc/subgid` (depending on whether is a UID or GID):
    ```
    nano /etc/subuid
    ```
    Add the following line (keep the existing `root:100000:65536` line):
    ```
    root:<ID>:1
    ```
    Where you replace `<ID>` with the actual ID.  

5. That's it.

## Adding more passthrough IDs (e.g. also passing through `1001` and `2002`)

If you need to pass through multiple non-contiguous IDs you need to split the mapping into more segments.  
Below is an example passing through both `1001` and `2002`:

1. Open the container config again:
    ```
    nano /etc/pve/lxc/<CTID>.conf
    ```

2. Replace the previous `lxc.idmap` lines with the following:
    ```
    # UIDs
    lxc.idmap: u 0 100000 1001
    lxc.idmap: u 1001 1001 1
    lxc.idmap: u 1002 101002 1000
    lxc.idmap: u 2002 2002 1
    lxc.idmap: u 2003 102003 63533

    # GIDs
    lxc.idmap: g 0 100000 1001
    lxc.idmap: g 1001 1001 1
    lxc.idmap: g 1002 101002 1000
    lxc.idmap: g 2002 2002 1
    lxc.idmap: g 2003 102003 63533
    ```

    > [!NOTE]
    > The ranges must be contiguous and non-overlapping and must together cover the full `0`–`65535` range.  
    > The `count` values in all segments must add up to `65536`.

3. Add the new IDs to `/etc/subuid` and `/etc/subgid` on the **Proxmox Host**:
    ```
    nano /etc/subuid
    ```
    Add:
    ```
    root:1001:1
    root:2002:1
    ```
    ```
    nano /etc/subgid
    ```
    Add:
    ```
    root:1001:1
    root:2002:1
    ```

4. That's it.
