# Home Assistant

**Home Assistant** is a smart home operating system, this branch contains the installation instructions for installing **Home Assistant** as a **Proxmox VM**.

## Preview

![preview image](docs/images/preview.png)

## Steps

1. From the **Proxmox** WebUI navigate to the **Node**'s **Shell**.

2. Start creation of the **Home Assistant VM** using the [community script](https://community-scripts.org/scripts/haos-vm):
    ```sh
    bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/vm/haos-vm.sh)"
    ```

3. Proceed with the installation and when asked "Use Default Settings?", choose **Advanced**.

4. Choose the latest **Stable** version.

5. Set the VM ID to `114` (matches with the VLAN).

6. Choose `q35` as the **Machine Type**.

7. I have given the `haos` VM a disk of **32GB**, also enable **Disk Cache** when prompted.

8. Set the **Hostname** to `haos` (or something else).

9. Choose **KVM64** as the **CPU Model**.

10. Give the VM **2vCPU**s and **2048MiB** of RAM.

11. For the (primary) **Network Bridge** set it to `vmbr1` and keep the default **MAC Address**.

12. Set the **VLAN tag** to `114` to get the proper firewall rules.

13. Leave **MTU Size** blank.

14. Select don't start the VM when completed. And create!

15. Go to the **Hardware** tab of the **VM** and double click on the **Hard Disk**. Make sure **Advanced Options** are enabled in the bottom right.

16. Disable **SSD emulation** and set **Cache** to **Write Back**. **Ok**!

17. Click on the **Serial Port** and hit **Remove**.

18. We also need it to be able to access our LAN, so hit **Add** and select **Network Device**. Select `vmbr0` and disable the built-in **firewall**. **Add**!

19. Now we can finally start the **VM**, go to the **Console** tab and hit **Start Now**.

20. Once everything has started you should see something like:
    ```
    Welcome to the Home Assistant command line interface.

    Hone Assistant Supervisor is running!
    System information:
        IPv4 addresses for enp6s19: 192.168.0.79/22
        IPv6 addresses for enp6s19: fe80::a099:1284:53a4:6423/64 
        IPv4 addresses for enp6s18: (No address)
        
        OS Version: Home Assistant OS 18.2
        Home Assistant Core: 2026.8.3

        Home Assistant URL: http://homeassistant.local:8123
        Observer URL: http://homeassistant.local:4357
        
    System is ready! Use browser or app to configure.
    ```

21. You can access **Home Assistant** on `http://homeassistant.local:8123` while it is still upgrading to the latest version. If you can't reach it it probably already upgraded and is now on port `80`, so you can access it on `http://homeassistant.local:80`.

22. But we don't want HTTP and having to use the local domain, we want it to use [`priv-net`](./../priv-net/README.md), so it has HTTPS and we have full control over the domain. So we'll need to give **Home Assistant** an IP and a gateway for our `114` VLAN. Start by taking note of the `enpXsXX` with no address in **Home Assistant** **Console**. It should look something like:
    ```
    System information:
        IPv4 addresses for enp6s19: 192.168.xxx.xxx/xx
        IPv6 addresses for enp6s19: xxxx::xxxx:xxxx:xxxx:xxxx/64 
        IPv4 addresses for enp6s18: (No address)
    ```
    So in this case it is `enp6s18`.

23. Now in the **Console** run this command:
    ```sh
    network update enpXsXX --ipv4-address 172.20.114.10/24 --ipv4-gateway 172.20.114.1
    ```
    Where you replace `enpXsXX` with the actual `enpXsXX` you found.

24. To see it worked run:
    ```sh
    exit
    ```
    After the information comes back up you should see:
    ```
    System information:
        IPv4 addresses for enp6s19: 192.168.xxx.xxx/xx
        IPv6 addresses for enp6s19: xxxx::xxxx:xxxx:xxxx:xxxx/64 
        IPv4 addresses for enp6s18: 172.20.114.10/24
        IPv6 addresses for enp6s18: xxxx::xxxx:xxxx:xxxx:xxxx/64 
    ```
    It worked!

25. Now you we can start configuring via the WebUI, go to `https://home.local.mydomain.com` where `mydomain.com` is your actual domain. This requires [`priv-net`](./../priv-net/README.md) to be up and running.

26. // TODO: Configure instructions

## Configuring

To add more functionality to **Home Assistant** we can use **Home Assistant**'s addons. The addons can be found in the addon store.  
This is located under **Settings** -> **Add-ons** -> **Add-on Store**.

### ESP Home

// TODO: ...

## Debugging

If you have any issues setting up `haos` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Home Assistant](https://www.home-assistant.io/installation/generic-x86-64) - Smart Home OS Installation Guide
- [ESP Home](https://esphome.io/) - Smart Home OS with ESP's
