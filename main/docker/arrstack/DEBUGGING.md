# Debugging

This file exists with the purpose of helping you debug your issues with `arrstack`. This is not a foolproof file, it may miss certain issues and steps.

## Issues

### Prowlarr can't find certain indexers

Some indexers are removed due to supposed no longer working.  
They can be gotten back by rolling back to an older version.

1. Open the proper directory:
  ```
  cd ~/docker
  cd arrstack
  ```

2. Open the compose file:
  ```
  nano compose.yaml
  ```

3. Change:
  ```
  image: lscr.io/linuxserver/prowlarr:latest
  ```
  To:
  ```
  image: lscr.io/linuxserver/prowlarr:2.3.0
  ```

### Slskd doesn't have permission

If **Slskd** doesn't have the proper permissions to access the `slskd` directory, check the docker logs using:
```
docker logs slskd
```
You'll see something like:
```
Filesystem exception: Directory /app is not writeable: Access to the path '/app/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' is denied.
Filesystem exception: Directory /app is not writeable: Access to the path '/app/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' is denied.
Filesystem exception: Directory /app is not writeable: Access to the path '/app/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' is denied.
Filesystem exception: Directory /app is not writeable: Access to the path '/app/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' is denied.
Filesystem exception: Directory /app is not writeable: Access to the path '/app/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' is denied.
Filesystem exception: Directory /app is not writeable: Access to the path '/app/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' is denied.
Filesystem exception: Directory /app is not writeable: Access to the path '/app/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' is denied.
Filesystem exception: Directory /app is not writeable: Access to the path '/app/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' is denied.
Filesystem exception: Directory /app is not writeable: Access to the path '/app/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx' is denied.
```
Or:
```
PermissionError: [Errno 13] Permission denied: '/data/.current_page.txt'
```

1. To fix this go to the `arrstack`.
   ```
   cd ~/docker
   cd arrstack
   ```

2. Now change the permissions of the `slskd` directory:
   ```
   sudo chown -R 1000:1000 slskd/
   ```
   And your issues will be resolved.

## Helping others

If you have found more issues while following the steps and figured it out please create a pull request with your issue and it's debugging steps and resolution.
