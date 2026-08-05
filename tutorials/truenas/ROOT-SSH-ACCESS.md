# Root SSH access to TrueNAS

This file contains the steps for enabling `root` **SSH** access into **TrueNAS**.  

## Steps

1. First navigate to the **TrueNAS** WebUI and login as an admin user.

2. Navigate to **Credentials** -> **Users** and edit the `root` user.

3. Enable **SSH Access**.

4. If you want easy access enable **Allow SSH Login with password** (not recommended). You can now **SSH** into the root user on the TrueNAS IP.

5. The more secure way is setting up **SSH** keys. The next instructions will explain how to do this.

6. First open a terminal on the machine you want to **SSH** from. // NOTE: These instructions are for linux systems

7. Generate **SSH** keys:
    ```sh
    ssh-keygen -t rsa -b 4096
    ```
    Press enter and enter a passphrase.

8. Read the contents of the public key:
    ```
    cat ~/.ssh/id_rsa.pub
    ```
    Copy the output.

9. Back in the **TrueNAS** WebUI paste the public key in the **Public SSH Key** field.

10. Save! You can now **SSH** into **TrueNAS** (provided you enable the **SSH** service under **System** -> **Services**)
