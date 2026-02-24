# NVIDIA Runtime in docker

This file contains setting up the NVIDIA Runtime for **Docker**.  
This allows us to use our NVIDIA GPU in docker containers. Ex. docker compose:  
```
environment:  
    - NVIDIA_DRIVER_CAPABILITIES=all  
    - NVIDIA_VISIBLE_DEVICES=all  
runtime: nvidia  
gpus: all  
```

## Steps

1. Before we can install the nvidia-runtime we must add the NVIDIA repository. Before that we must retrieve the GPG key like so:
    ```
    mkdir -p /usr/share/keyrings
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
    ```

2. Now we'll add the repository:
    ```
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
    ```
   
3. Now install the container toolkit:
    ```
    sudo apt update
    sudo apt install -y nvidia-container-toolkit
    ```

4. Configure docker to use the NVIDIA runtime:
    ```
    nvidia-ctk runtime configure --runtime=docker
    systemctl restart docker
    ```

5. Verify its install with:
    ```
    docker info | grep -i runtime
    ```
    You should see:
    ```
    Runtimes: runc io.containerd.runc.v2 nvidia
    ```

At the time of writing this there is an issue with the current NVIDIA drivers:  
```
Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: error during container init: error running prestart hook #0: exit status 1, stdout: , stderr: Auto-detected mode as 'legacy'
nvidia-container-cli: mount error: failed to add device rules: unable to find any existing device filters attached to the cgroup: bpf_prog_query(BPF_CGROUP_DEVICE) failed: operation not permitted
```

To resolve this issue manually I have provided steps from [here](https://github.com/NVIDIA/nvidia-container-toolkit/issues/1246#issuecomment-3194219487)

1. Run these commands:
    ```
    sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
    sudo nvidia-ctk config --in-place --set nvidia-container-runtime.mode=cdi && sudo systemctl restart docker
    ```
    If you're running as `root` remove `sudo`:
    ```
    nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
    nvidia-ctk config --in-place --set nvidia-container-runtime.mode=cdi && systemctl restart docker
    ```
