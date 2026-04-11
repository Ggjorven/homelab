# pi2w-2

`pi2w-2` is a **Raspberry Pi Zero 2 W** used for **PiKVM**.  
This folder contains the installation instructions and configuration files used for this device.

## Steps // TODO: More detail

1. Use the [Raspberry Pi Imager](https://www.raspberrypi.com/software/) to install **Raspberry Pi OS Lite (32-bit)** on your **Pi Zero 2 W**.

2. SSH into your **Pi Zero 2 W** using the following command:
    ```
    ssh <username>@<ip address of pi zero 2 w>
    ```

3. Make sure your **Pi Zero 2 W** is up to date using the following commands:
    ```
    sudo apt update && sudo apt upgrade -y
    sudo reboot
    ```

4. // TODO: PiKVM

## Debugging

If you have any issues setting up `pi2w-2` checkout my [debugging guide](DEBUGGING.md). If you still can't figure it out, create a github issue or contact me personally.

## References

- [Raspberry Pi Imager](https://www.raspberrypi.com/software/) - Raspberry Pi Imager

