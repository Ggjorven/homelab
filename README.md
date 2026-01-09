# Homepage

Homepage is a dashboard service run as an **LXC container**, this branch contains the `/config` folder of the `/opt/homepage/` folder.

## Preview

![Preview of Dashboard](docs/images/preview.png)

## Installation

1. Install homepage as an **LXC Container** with the [community script](https://community-scripts.github.io/ProxmoxVE/scripts?id=homepage) in the Proxmox's node's shell.
   
2. Remove `/opt/homepage/config` folder.

3. Clone the repository into the `/opt/homepage/config` folder:
  ```sh
  git clone https://github.com/Ggjorven/homelab.git -b homepage /opt/homepage/config
  ```

4. Create or modify the `.env` in `/opt/homepage/` following this format replacing the placeholders with actual values.
  ```env
  HOMEPAGE_ALLOWED_HOSTS=192.168.x.x:3000
  
  HOMEPAGE_VAR_PROXMOX_IP=192.168.x.x
  HOMEPAGE_VAR_PROXMOX_URL=https://192.168.x.x:8006
  HOMEPAGE_VAR_PROXMOX_USERNAME=xxxxx@pam!xxxxx
  HOMEPAGE_VAR_PROXMOX_SECRET=
  
  HOMEPAGE_VAR_TRUENAS_IP=192.168.x.x
  HOMEPAGE_VAR_TRUENAS_URL=https://192.168.x.x
  HOMEPAGE_VAR_TRUENAS_USERNAME=
  HOMEPAGE_VAR_TRUENAS_PASSWORD=
  
  HOMEPAGE_VAR_PIHOLE_IP=192.168.x.x
  HOMEPAGE_VAR_PIHOLE_URL=https://192.168.x.x
  HOMEPAGE_VAR_PIHOLE_PASSWORD=
  ```

<br>

---

<br>

Sometimes it's also required to set:
```
EnvironmentFile=/opt/homepage/.env
```

under
```
[Service]
```

in `/etc/systemd/system/homepage.service`.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Homepage](https://github.com/gethomepage/homepage) - Dashboard
