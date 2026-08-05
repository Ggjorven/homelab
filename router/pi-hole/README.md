# PiHole

**PiHole** is an adblocking DNS server, this branch contains the installation instructions for installing **PiHole** as a **Proxmox LXC**.

## Steps

1. From the **Proxmox Node**'s shell install a **PiHole LXC** using the [community script](https://community-scripts.org/scripts?q=PiHole):
    ```sh
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/pihole.sh)"
    ```

2. Choose `Advanced Install`. Go through the installation and choose your desired settings and specifications. I have given it `1vCPU`, `512MiB` of RAM and a `16GB` disk, you can keep the rest default.

3. Make sure that when your installing you enable, **keyctl**, **nesting**, **gpu passthrough**, **TUN/TAP** and add `ext4` as a filesystem mount.

4. Go to the **Pi Zero 2 W**'s ip-address in a web browser and login. Now navigate to the **Lists** section and individually add each address in [block_lists](block_lists.txt) with **Add blocklist**.

5. Now go to **Settings/Privacy** and switch from **Basic** to **Expert** in the top-right. 

6. Disable **Log DNS queries and replies** and set **Query Anonymization** to **Anonymous Mode**.

7. Now start enjoying your ad-free browsing experience by setting your **Pi Zero 2 W**'s ip-address as a DNS server in your router.

## Debugging

If you have any issues setting up `pihole` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [PiHole install script](https://community-scripts.org/scripts?q=PiHole) - PiHole install script
