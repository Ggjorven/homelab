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

## Helping others

If you have found more issues while following the steps and figured it out please create a pull request with your issue and it's debugging steps and resolution.
