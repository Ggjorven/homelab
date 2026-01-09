# Homepage

Homepage is a dashboard service run as an **LXC container**, this branch contains the /config folder of the /opt/homepage/ folder.

## Before deploying

Before you can deploy the homepage with this configuration you must create a .env file in the /opt/homepage/ folder with these contents:

```env
HOMEPAGE_ALLOWED_HOSTS=192.168.x.x:3000

PROXMOX_IP=192.168.x.x
PROXMOX_URL=https://192.168.x.x:8006
PROXMOX_USERNAME=xxxxx@pam!xxxxx
PROXMOX_SECRET=

TRUENAS_IP=192.168.x.x
TRUENAS_URL=https://192.168.x.x
TRUENAS_USERNAME=
TRUENAS_PASSWORD=

PIHOLE_IP=192.168.x.x
PIHOLE_URL=https://192.168.x.x
PIHOLE_PASSWORD=
```

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Homepage](https://github.com/gethomepage/homepage) - Dashboard
