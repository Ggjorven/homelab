# pi2w-2

`pi2w-2` is a **Raspberry Pi 2 W** connected via ethernet and used for lightweight network services in my homelab.  
This branch contains the installation instructions and configuration files used for this device.

## Installation // TODO: More detail

1. Use the [Raspberry Pi Imager](https://www.raspberrypi.com/software/) to install **Raspberry Pi OS Lite (32-bit)** on your **Pi 2 W**.

2. SSH into your **Pi 2 W** using the following command:
    ```
    ssh <username>@<ip address of pi2w-1>
    ```

3. Make sure your **Pi 2 W** is up to date using the following commands:
    ```
    sudo apt update && sudo apt upgrade -y
    sudo reboot
    ```

4. You can now follow the instructions for 
    - [`pivpn`](https://github.com/Ggjorven/homelab/blob/main/pi2w-2/pivpn/README.md)

## References

- [Raspberry Pi Imager](https://www.raspberrypi.com/software/) - Raspberry Pi Imager

