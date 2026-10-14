# Pi-hole

Pi-hole is a custom DNS server and used as a network wide adblocker in my case, it's deployed directly on a **Pi Zero 2 w** connected via ethernet. This branch contains the installation instructions and files used during the installation.

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

3. Once you're back in install Pi-hole using the following command:
    ```
    curl -sSL https://install.pi-hole.net | bash
    ```

4. Wait until prompted to **Continue** or **Exit** based on if you have set up static IP's. Select **Continue**!

5. When prompted to enable **Query logging** disable it.

6. For **Query Anonymization** select **Anonymous mode**.

7. After the install has finished you'll see a screen with your IP and a password. Remember this IP and either remember this password or set it manually:
    ```sh
    sudo pihole setpassword
    ```

8. Go to the **Pi Zero 2 W**'s ip-address in a web browser and login with either the generated password or the password you just set. 

9. Now navigate to the **Lists** section and individually add each address in [block_lists](block_lists.txt) with **Add blocklist**.

10. To actually enable the lists go to **Tools** -> **Update Gravity** and hit **Update**.

11. Now start enjoying your ad-free browsing experience by setting your **Pi Zero 2 W**'s ip-address as a DNS server in your router.

## Extra notes

The reason these are instructions and not easily deployable files is because alongside all the settings in pi-hole's files there are password hashes and ip-addresses I don't want to risk uploading.

## References

- [Pi-hole](https://www.pi-hole.net) - Custom DNS server for easy network wide adblocking & more...
