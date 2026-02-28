# Debugging

This file exists with the purpose of helping you debug your issues with `tvstack`. This is not a foolproof file, it may miss certain issues and steps.

## Issues

### NVIDIA Runtime creation failed

If you get something like:
```
Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: error during container init: error running prestart hook #0: exit status 1, stdout: , stderr: Auto-detected mode as 'legacy'
nvidia-container-cli: mount error: failed to add device rules: unable to find any existing device filters attached to the cgroup: bpf_prog_query(BPF_CGROUP_DEVICE) failed: operation not permitted
```
when starting a container that requires `runtime: nvidia`. You'll find the steps to resolve this issue here.

1. Make sure you're `root`:
    ```
    su root
    ```
    
2. Run these commands:
    ```
    nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
    nvidia-ctk config --in-place --set nvidia-container-runtime.mode=cdi && systemctl restart docker
    ```
    Taken from [here](https://github.com/NVIDIA/nvidia-container-toolkit/issues/1246#issuecomment-3194219487).

The solution for this issue can also be found at the bottom of **Steps** in [docker NVIDIA runtime](../../../tutorials/docker/NVIDIA-RUNTIME.md).

### 502 Bad Gateway

If **Dispatcharr** doesn't have the proper permissions to access the `dispatcharr` directory, check the docker logs using:
```
docker logs dispatcharr
```

1. Roll back the **Dispatcharr** image to and older version. Navigate to the proper directory:
    ```
    cd ~/docker
    cd musicstack
    ```
  
2. Open the compose file:
    ```
    nano compose.yaml
    ```

3. Replace:
    ```
    image: deluan/navidrome:latest
    ```
    With:
    ```
    image: deluan/navidrome:0.20.0
    ```
    Or any other older version.

Related github issues: [#721](https://github.com/Dispatcharr/Dispatcharr/issues/721)

## Helping others

If you have found more issues while following the steps and figured it out please create a pull request with your issue and it's debugging steps and resolution.
