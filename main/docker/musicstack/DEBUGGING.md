# Debugging

This file exists with the purpose of helping you debug your issues with `musicstack`. This is not a foolproof file, it may miss certain issues and steps.

## Issues

### Navidrome failed to start/Navidrome permission issue

If **Navidrome** doesn't have the proper permissions to access the `navidrome` directory, check the docker logs using:
```
docker logs navidrome
```
You'll see something like:
```
FATAL: Error creating cache path: mkdir /data/cache: permission denied
```

1. To fix this go to the `musicstack`.
   ```
   cd ~/docker
   cd musicstack
   ```

2. Now change the permissions of the `navidrome` directory:
   ```
   sudo chown -R 1000:1000 navidrome/
   ```
   And your issues will be resolved.

## Helping others

If you have found more issues while following the steps and figured it out please create a pull request with your issue and it's debugging steps and resolution.
