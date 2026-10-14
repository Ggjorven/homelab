# PiVPN

PiVPN is a VPN service that allows you to connect to your home network from anywhere, this branch contains the installation instructions for installing **PiVPN** on a **Pi Zero 2 W**.

## Installation

1. SSH into your **Pi Zero 2 W** using the following command:
    ```
    ssh <username>@<ip address of pi zero 2 w>
    ```

2. Make sure your **Pi Zero 2 W** is up to date using the following commands:
    ```
    sudo apt update && sudo apt upgrade -y
    sudo reboot
    ```

3. Once you're back in install PiVPN using [these instructions](https://docs.pivpn.io/install/).
    ```
    curl -L https://install.pivpn.io | bash
    ```

4. The installer will ask to force IPv6 traffic through the VPN say **Yes**.

5. Next it will ask about **DHCP Reservation**, even if you have setup reservation it is recommended to say **No** and just say **Yes** on the screen after that to use the current IP and gateway for the static address.

6. Now select your user where the configurations will be stored.

7. When the installer asks for which provider to use select **Wireguard** and hit enter to continue.

8. Next it will ask what port to be on, the default is `51820`, I recommend [generating a random port](https://it-tools.tech/random-port-generator) and using that, then **Confirm**.

9. If you have set up [`pi-hole`](./../pihole/README.md) on this device it should now detect it and ask to use that as the DNS server, say **Yes**, else set it to **Cloudflare**.

10. Now under **Public IP or DNS** set it to **DNS Entry** (by selecting it with space) if you have a domain (recommended) and set it to your domain like `vpn.example.com` and **Confirm**, otherwise set it to **Public IP**.

11. Now for security enable **Unattended Upgrades**.

12. Your installation should now be complete and hit **Ok** and hit **Yes** when it asks to **Reboot**.

13. After you reconnect you can now start adding users with:
    ```
    pivpn add
    ```
    Skip the IP address step and press Enter. Now give the client a name like `phone-name`

14. Before we can connect to **PiVPN** we need to import the client profiles to the device we want to connect with. The client profiles are located in `/home/<USERNAME>/configs`. These instructions are platform specific.
    **Windows:**  
    Use a program like WinSCP or Cyberduck. Note that you may need administrator permission to move files to some folders on your Windows machine, so if you have trouble transferring the profile to a particular folder with your chosen file transfer program, try moving it to your desktop.  
    
    **Mac/Linux:**  
    // TODO: ...

    Extra information can be found [here](https://docs.pivpn.io/wireguard/#windows).

15. Connecting to the **PiVPN** server differs on every platform. [Here](https://docs.pivpn.io/wireguard/#windowsmac) you can find more information. For this example I will use an **Android Phone**.
    // TODO: ...

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [PiVPN](https://www.pivpn.io/) - VPN Service
- [Install Wireguard](https://www.wireguard.com/install/) - Wireguard installation
- [Extra docs](https://docs.pivpn.io/wireguard/) - Wireguard documentation for PiVPN
