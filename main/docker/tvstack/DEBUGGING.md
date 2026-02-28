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

1. To fix this go to the `tvstack`.
   ```
   cd ~/docker
   cd tvstack
   ```

2. Now change the permissions of the `dispatcharr` directory:
   ```
   sudo chown -R 1000:1000 dispatcharr/
   ```
   And your issues will be resolved.

## Helping others

If you have found more issues while following the steps and figured it out please create a pull request with your issue and it's debugging steps and resolution.
