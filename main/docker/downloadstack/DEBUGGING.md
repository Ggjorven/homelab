# Debugging

This file exists with the purpose of helping you debug your issues with `downloadstack`. This is not a foolproof file, it may miss certain issues and steps.

## Issues

### Metube keeps restarting

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
   
## Helping others

If you have found more issues while following the steps and figured it out please create a pull request with your issue and it's debugging steps and resolution.
