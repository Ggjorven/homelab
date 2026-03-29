# Bazarr Sync

If you wish to retroactively synchronize your subtitles you can use [bazarr sync](https://github.com/ajmandourah/bazarr-sync).

## Steps

1. Create a temporary folder:
    ```
    cd ~/docker
    mkdir temp
    cd temp
    ```

2. Create a compose.yaml:
    ```
    touch compose.yaml
    nano compose.yaml
    ```
    Paste:
    ```
    networks:
      internalnetwork:
        external: true

      externalnetwork:
        external: true

    services:
      bazarr-sync:
        image: ghcr.io/ajmandourah/bazarr-sync:latest
        container_name: bazarr-sync
        volumes:
          - ./config.yaml:/usr/src/app/config.yaml
        networks:
          - internalnetwork
        command: bazarr-sync sync movies
    ```

3. Create a config.yaml file:
    ```
    touch config.yaml
    nano config.yaml
    ```
    Paste:
    ```
    ###########################
    # Config file example
    ###########################
    #
    # Address: the address of your bazarr instance. this can be either an ip address or a url (if you reverse proxy bazarr), 
    Address: 192.168.xxx.xxx
    
    # Port: bazarrs port. by default bazarr uses 6767. in case of reverse proxy, you can use 443 or 80 as per your configuration 
    Port: 6767
    
    # Protocol: this can be http or https
    Protocol: http
    
    # ApiToken: you can get this from bazarr Settings > General.
    ApiToken: <APITOKEN>
    ```

4. Replace the `Address` with your Docker LXC's IP address.

5. Replace the `ApiToken` with your API token from **Bazarr** under **Settings** -> **General**.

6. Now start the stack and monitor the output:
    ```
    docker compose up
    ```

7. After the movies are finished edit compose.yaml change to shows:
    ```
    nano compose.yaml
    ```
    And change `movies` to `shows` under:
    ```
    command: bazarr-sync sync movies
    ```

8. Now restart the stack and monitor the output:
    ```
    docker compose up
    ```

9. All done!
