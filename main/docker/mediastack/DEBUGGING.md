# Debugging

This file exists with the purpose of helping you debug your issues with `mediastack`. This is not a foolproof file, it may miss certain issues and steps.

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

### Seerr doesn't have permission

If **Seerr** doesn't have the proper permissions to access the `seerr` directory, check the docker logs using:
```
docker logs seerr
```
You'll see something like:
```
Error: EACCES: permission denied, mkdir '/app/config/logs/'
    at Object.mkdirSync (node:fs:1377:26)
    at /app/node_modules/.pnpm/file-stream-rotator@0.6.1/node_modules/file-stream-rotator/FileStreamRotator.js:669:24
    at Array.reduce (<anonymous>)
    at mkDirForFile (/app/node_modules/.pnpm/file-stream-rotator@0.6.1/node_modules/file-stream-rotator/FileStreamRotator.js:656:27)
    at FileStreamRotator.getStream (/app/node_modules/.pnpm/file-stream-rotator@0.6.1/node_modules/file-stream-rotator/FileStreamRotator.js:532:5)
    at new DailyRotateFile (/app/node_modules/.pnpm/winston-daily-rotate-file@4.7.1_winston@3.19.0/node_modules/winston-daily-rotate-file/daily-rotate-file.js:80:57)
    at Object.<anonymous> (/app/dist/logger.js:46:9)
    at Module._compile (node:internal/modules/cjs/loader:1706:14)
    at Object..js (node:internal/modules/cjs/loader:1839:10)
    at Module.load (node:internal/modules/cjs/loader:1441:32) {
  errno: -13,
  code: 'EACCES',
  syscall: 'mkdir',
  path: '/app/config/logs/'
}
```

1. To fix this go to the `mediastack`.
   ```
   cd ~/docker
   cd mediastack
   ```

2. Now change the permissions of the `seerr` directory:
   ```
   chown -r 1000:1000 seerr/
   ```
   And your issues will be resolved.

### Jellystat doesn't have permission/Can't create user

If **Jellystat** doesn't have the proper permissions to access the `jellystat` directory or when creating a user in **Jellystat** nothing happens, check the docker logs using:
```
docker logs jellystat
```
You'll see something like:
```
[JELLYSTAT]: Error occurred while executing query: could not open file "base/xxxxx/xxxxx_fsm": Permission denied
[JELLYSTAT]: Error occurred while executing query: could not open file "global/pg_filenode.map": Permission denied
```

1. To fix this go to the `mediastack`.
   ```
   cd ~/docker
   cd mediastack
   ```

2. Now change the permissions of the `jellystat` directory:
   ```
   chown -r 1000:1000 jellystat/
   ```
   And your issues will be resolved.

## Helping others

If you have found more issues while following the steps and figured it out please create a pull request with your issue and it's debugging steps and resolution.
