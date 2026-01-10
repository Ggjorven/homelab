# Pi-hole

Pi-hole is a custom DNS server and used as a network wide adblocker in my case, it's deployed directly on a **Pi 2 w** connected via ethernet. This branch contains the installation instructions and files used during the installation.

## Installation

1. Use the [Raspberry Pi Imager](https://www.raspberrypi.com/software/) to install **Raspberry Pi OS Lite (32-bit)** on your **Pi 2 W**.

2. SSH into your **Pi 2 W** using the following command:
    ```
    ssh <username>@<ip address of pi 2 w>
    ```

3. Make sure your **Pi 2 W** is up to date using the following commands:
    ```
    sudo apt update && sudo apt upgrade -y
    sudo reboot
    ```

4. Once you're back in install Pi-hole using the following command:
    ```
    curl -sSL https://install.pi-hole.net | bash
    ```

5. Go to the **Pi 2 W**'s ip-address in a web browser and login. Now navigate to the **Lists** section and individually add each address in [block_lists](block_lists.txt) with **Add blocklist**.

6. Now go to **Settings/Privacy** and switch from **Basic** to **Expert** in the top-right. 

7. Disable **Log DNS queries and replies** and set **Query Anonymization** to **Anonymous Mode**.

8. Now start enjoying your ad-free browsing experience by setting your **Pi 2 W**'s ip-address as a DNS server in your router.

## Extra notes

The reason these are instructions and not easily deployable files is because alongside all the settings in pi-hole's files there are password hashes and ip-addresses I don't want to risk uploading.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Raspberry Pi Imager](https://www.raspberrypi.com/software/) - Imaging tool for raspberry pi
- [Pi-hole](https://www.pi-hole.net) - Custom DNS server for easy network wide adblocking & more...
