# TV Stack

**TV Stack** is a collection of Live TV streaming tools for streaming my content from any device, this branch contains the installation instructions for installing **Dispatcharr & More** using **Docker Compose**.

## Installation

1. From the **Proxmox Node**'s shell install a **Docker LXC** using the [community script](https://community-scripts.github.io/ProxmoxVE/scripts?id=docker):
   ```
   bash -c "$(curl -fsSL https://raw.githubusercontent.com/community-scripts/ProxmoxVE/main/ct/docker.sh)"
   ```

2. To give docker access to our GPU we need to install the nvidia-runtime, before we can do so we need to add the NVIDIA repository. We'll start by adding the GPG key:
   ```
   mkdir -p /usr/share/keyrings
   curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
   ```

3. Now we'll add the repository:
   ```
   distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
   curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
   sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
   tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
   ```
   
4. Now install the container toolkit:
    ```
    sudo apt update
    sudo apt install -y nvidia-container-toolkit
    ```

5. Configure docker to use the NVIDIA runtime:
   ```
   nvidia-ctk runtime configure --runtime=docker
   systemctl restart docker
   ```

6. Verify its install with:
   ```
   docker info | grep -i runtime
   ```
   You should see:
   ```
   Runtimes: runc io.containerd.runc.v2 nvidia
   ```

7. Now we can actually start setting up the docker stack. We first need to create a nice place to work in:
    ```
    mkdir -p /docker
    ```

8. To create the docker stack we use our premade [compose file](https://github.com/Ggjorven/homelab/blob/tvstack/tvstack.yaml). But before we can do so we need to install `wget`.
    ```
    apt install wget
    ```
    Now we can run:
    ```
    cd /docker
    wget https://raw.githubusercontent.com/Ggjorven/homelab/refs/heads/tvstack/tvstack.yaml
    ```

9. Now modify your `.env` file.
    ```
    nano .env
    ```
    And make sure this is present:
    ```
    # General UID/GIU and Timezone
    TZ=Europe/Amsterdam
    PUID=1000
    PGID=1000

    # Database credentials
    # TODO: ...
    ```

10. Also make sure the `PUID` and `PGID` are set to your actual IDs in `.env` you can check this with this command *(your user is probably `root`)*:
    ```
    id <YOUR USER>
    ```
    If you run into errors also check [this](https://github.com/TechHutTV/homelab/tree/main/media#user-permissions).

11. We are now finally ready to start our docker stack.
    ```
    docker compose -f gluetun.yaml -f arrstack.yaml -f jellystack.yaml -f tvstack.yaml up -d
    ```

---

If you have any issues like:  
`
Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: error during container init: error running prestart hook #0: exit status 1, stdout: , stderr: Auto-detected mode as 'legacy'
nvidia-container-cli: mount error: failed to add device rules: unable to find any existing device filters attached to the cgroup: bpf_prog_query(BPF_CGROUP_DEVICE) failed: operation not permitted
`  
*Check out [this comment](https://github.com/NVIDIA/nvidia-container-toolkit/issues/1246#issuecomment-3194219487)*

## Configuration

### Dispatcharr

// TODO: ...

## Final step    

Finally we need to make it so our **TV stack** starts on bootup of the **Proxmox LXC**. For ease of use I have created a **systemctl service** and a **bash script** to help with this. You should have installed these when creating the `gluetun` stack. Now modify the script and add:
```
-f tvstack.yaml
```
to it. Do the same to the `compose-update.sh` script.
To enable this service we run these commands:
```
systemctl daemon-reload
systemctl enable compose-boot
systemctl start compose-boot
```
Now you're all set.

## Contributing

Contributions are welcome! Please fork the repository and create a pull request with your changes.

## References

- [Proxmox](https://www.proxmox.com) - Hypervisor
- [Dispatcharr](https://github.com/Dispatcharr/Dispatcharr) - M3U & Xtream Proxy
