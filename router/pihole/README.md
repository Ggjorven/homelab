# PiHole

**PiHole** is an adblocking DNS server, this branch contains the installation instructions for installing **PiHole** as a **Proxmox LXC**.

## Steps

1. TODO: ...

4. Go to the **Pi Zero 2 W**'s ip-address in a web browser and login. Now navigate to the **Lists** section and individually add each address in [block_lists](block_lists.txt) with **Add blocklist**.

5. Now go to **Settings/Privacy** and switch from **Basic** to **Expert** in the top-right. 

6. Disable **Log DNS queries and replies** and set **Query Anonymization** to **Anonymous Mode**.

7. Now start enjoying your ad-free browsing experience by setting your **Pi Zero 2 W**'s ip-address as a DNS server in your router.

## Debugging

If you have any issues setting up `pihole` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [PiHole install script](https://community-scripts.org/scripts?q=PiHole) - PiHole install script
