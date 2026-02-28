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

### Jellyfin doesn't have permission/Jellyfin doesn't boot

If **Jellyfin** doesn't have the proper permissions to access the `jellyfin` directory, check the docker logs using:
```
docker logs jellyfin
```
You'll see something like:
```
mkdir: cannot create directory ‘/config/log’: Permission denied
mkdir: cannot create directory ‘/config/data’: Permission denied
mkdir: cannot create directory ‘/config/data’: Permission denied
mkdir: cannot create directory ‘/config/cache’: Permission denied
mkdir: cannot create directory ‘/transcode’: Permission denied
```

1. To fix this go to the `mediastack`.
   ```
   cd ~/docker
   cd mediastack
   ```

2. Now change the permissions of the `jellyfin` directory:
   ```
   sudo chown -R 1000:1000 jellyfin/
   ```
   And your issues will be resolved.

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
   sudo chown -R 1000:1000 seerr/
   ```
   And your issues will be resolved.

### Jellystat doesn't have permission

If **Jellystat** doesn't have the proper permissions to access the `jellystat` directory, check the docker logs using:
```
docker logs jellystat
```
You'll see something like:
```
[JELLYSTAT]: Error occurred while executing query: could not open file "base/xxxxx/xxxxx_fsm": Permission denied
[JELLYSTAT]: Error occurred while executing query: could not open file "global/pg_filenode.map": Permission denied
```
or
```
error: could not open file "global/pg_filenode.map": Permission denied
    at Parser.parseErrorMessage (/app/node_modules/pg-protocol/dist/parser.js:285:98)
    at Parser.handlePacket (/app/node_modules/pg-protocol/dist/parser.js:122:29)
    at Parser.parse (/app/node_modules/pg-protocol/dist/parser.js:35:38)
    at Socket.<anonymous> (/app/node_modules/pg-protocol/dist/index.js:11:42)
    at Socket.emit (node:events:519:28)
    at addChunk (node:internal/streams/readable:561:12)
    at readableAddChunkPushByteMode (node:internal/streams/readable:512:3)
    at Readable.push (node:internal/streams/readable:392:5)
    at TCP.onStreamRead (node:internal/stream_base_commons:189:23)
[JELLYSTAT] Database exists. Skipping creation
FS-related option specified for migration configuration. This resets migrationSource to default FsMigrations
FS-related option specified for migration configuration. This resets migrationSource to default FsMigrations
/app/node_modules/pg-protocol/dist/parser.js:285
        const message = name === 'notice' ? new messages_1.NoticeMessage(length, messageValue) : new messages_1.DatabaseError(messageValue, length, name);
                                                                                                 ^

error: could not open file "global/pg_filenode.map": Permission denied
    at Parser.parseErrorMessage (/app/node_modules/pg-protocol/dist/parser.js:285:98)
    at Parser.handlePacket (/app/node_modules/pg-protocol/dist/parser.js:122:29)
    at Parser.parse (/app/node_modules/pg-protocol/dist/parser.js:35:38)
    at Socket.<anonymous> (/app/node_modules/pg-protocol/dist/index.js:11:42)
    at Socket.emit (node:events:519:28)
    at addChunk (node:internal/streams/readable:561:12)
    at readableAddChunkPushByteMode (node:internal/streams/readable:512:3)
    at Readable.push (node:internal/streams/readable:392:5)
    at TCP.onStreamRead (node:internal/stream_base_commons:189:23) {
  length: 127,
  severity: 'FATAL',
  code: '42501',
  detail: undefined,
  hint: undefined,
  position: undefined,
  internalPosition: undefined,
  internalQuery: undefined,
  where: undefined,
  schema: undefined,
  table: undefined,
  column: undefined,
  dataType: undefined,
  constraint: undefined,
  file: 'relmapper.c',
  line: '790',
  routine: 'read_relmap_file'
}
```

1. To fix this go to the `mediastack`.
   ```
   cd ~/docker
   cd mediastack
   ```

2. Now change the permissions of the `jellystat` directory:
   ```
   sudo chown -R 1000:1000 jellystat/
   ```
   And your issues will be resolved.

### Jellystat can't create user/Jellystat won't boot

If **Jellystat** can't create a new user in **Jellystat**, check the docker logs using:
```
docker logs jellystat
```
And:
```
docker logs jellystat-db
```

You'll see something like:
```
2026-02-28 18:32:16.164 UTC [1046] FATAL:  could not open file "global/pg_filenode.map": Permission denied
2026-02-28 18:32:16.172 UTC [1047] FATAL:  could not open file "global/pg_filenode.map": Permission denied
2026-02-28 18:32:16.700 UTC [27] LOG:  checkpoint starting: time
2026-02-28 18:32:16.700 UTC [27] ERROR:  could not open directory "pg_logical/snapshots": Permission denied
```

1. Make sure the user in the docker compose.yaml is set properly
    ```
    # Or use the .env arguments
    user: XXXX:XXXX
    ```

## Helping others

If you have found more issues while following the steps and figured it out please create a pull request with your issue and it's debugging steps and resolution.
