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

8. Next it will ask what port to be on, the default is `51820`, I recommend [generating a random port](https://it-tools.tech/random-port-generator) and using that, then **Confirm**q.

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

16. (optional) If you are using the VPN from a **DNS Entry** like `vpn.example.com` you must ensure that the domain keeps pointing to your actual public IP by using ddns. I will be showing it for **Cloudflare**.

17. (optional) Create a directory for our DDNS script:
    ```sh
    sudo mkdir -p /pi2w/scripts
    ```

18. (optional) Now download my DDNS script:
    ```sh
    BRANCH=main
    cd /pi2w/scripts
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/pi2w-1/pivpn/scripts/cloudflare-ddns.sh"
    sudo chmod +x cloudflare-ddns.sh
    ```

19. (optional) Before you can run it you must create an API key for the script to use to update your cloudflare DNS record. Go to [https://dash.cloudflare.com/](https://dash.cloudflare.com/).

20. (optional) Now in the top-right select **Profile**.

21. (optional) Then navigate to **API Tokens** and hit **Create Token**.

22. (optional) Use the **Edit zone DNS** template.

23. (optional) It is highly recommened to change the **Token name** to something more memorable like `pi2w-1 cloudflare-ddns`.

24. (optional) Then under **Zone Resources** after **Specific Zone** select the domain you are using. Scroll down and hit **Continue to summary** and then **Create Token**.

25. (optional) Copy your token and back in the SSH session open the script:
    ```sh
    sudo nano /pi2w/scripts/cloudflare-ddns.sh
    ```
    Replace the `DOMAINS` with your domain, (ex. `vpn.example.com`).  
    Also replace the value under `API_KEY` with the just copied key.

26. (optional) Now make a system timer to run the DDNS update periodically:
    ```sh
    BRANCH=main
    cd /etc/systemd/system
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/pi2w-1/pivpn/services/cloudflare-ddns.service"
    sudo wget "https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/$BRANCH/pi2w-1/pivpn/services/cloudflare-ddns.timer"
    ```

27. (optional) Enable the timer:
    ```sh
    sudo systemctl daemon-reload
    sudo systemctl enable --now cloudflare-ddns.timer
    ```

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [PiVPN](https://www.pivpn.io/) - VPN Service
- [Install Wireguard](https://www.wireguard.com/install/) - Wireguard installation
- [Extra docs](https://docs.pivpn.io/wireguard/) - Wireguard documentation for PiVPN
