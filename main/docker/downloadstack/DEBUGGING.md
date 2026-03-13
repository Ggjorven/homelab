# Debugging

This file exists with the purpose of helping you debug your issues with `downloadstack`. This is not a foolproof file, it may miss certain issues and steps.

## Debugging steps

To debug any issues with `downloadstack` use the following steps:

1. // TODO: ...

## Issues

### MeTube keeps restarting

If metube keeps restarting, check the docker logs using:
```
docker logs metube
```
You'll see something like:
```
PermissionError: [Errno 13] Permission denied: '/config/queue'
```

1. To fix this go to the `downloadstack`.
   ```
   cd ~/docker
   cd downloadstack
   ```

2. Now change the permissions of the `metube` directory:
   ```
   sudo chown -R 1000:1000 metube/
   ```
   And your issues will be resolved.

3. If your issues are not resolved restart metube:
   ```
   docker compose down metube
   docker compose up -d metube
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

1. To fix this go to the `downloadstack`.
   ```
   cd ~/docker
   cd downloadstack
   ```

2. Now change the permissions of the `slskd` directory:
   ```
   sudo chown -R 1000:1000 slskd/
   ```
   And your issues will be resolved.   

## Helping others

If you have found more issues while following the steps and figured it out please create a pull request with your issue and it's debugging steps and resolution.
