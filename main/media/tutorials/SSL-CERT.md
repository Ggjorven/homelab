# SSL Cert

There are multiple ways to convert a HTTP website to an HTTPS site. All methods require an SSL certificate. This file contains multiple tutorials for getting SSL certificates.

## Let's encrypt (Recommended)

> [!NOTE]
> These instructions require the DNS servers to be set to cloudflare's.

1. Go to [cloudflare.com](https://dash.cloudflare.com) and login.

2. Go to **Profile** -> **API Tokens**.

3. Click **Create Token** and select **Edit Zone DNS**.

4. Under **Zone Resources** click `Select...` and select your domain. Now scroll to the bottom hit **Continue** and **Create**.

5. Create a temporary directory to work in:
    ```
    mkdir -p temp
    cd temp
    mkdir -p certs
    ```

6. Create a cloudflare.ini file with your just created API token.
    ```
    touch cloudflare.ini
    nano cloudflare.ini
    ```
    Paste:
    ```
    dns_cloudflare_api_token = <APITOKEN>
    ```
    Replace `<APITOKEN>` with your actual API token.

7. Create a compose.yaml with certbot:
    ```
    nano compose.yaml
    ```
    And paste:
    ```
    services:
      certbot:
        image: certbot/dns-cloudflare
        volumes:
          - ./certs:/etc/letsencrypt
          - ./cloudflare.ini:/cloudflare.ini:ro
    ```

8. Now set an environment variable for this terminal session for the domain you want to generate an SSL certificate for + the email associated with it:
    ```
    DOMAIN="example.com"
    EMAIL="example@email.com"
    ```

9. Run this command to generate the certificate:
    ```
    docker compose run --rm certbot certonly --dns-cloudflare --dns-cloudflare-credentials /cloudflare.ini --agree-tos --email ${EMAIL} --no-eff-email -d ${DOMAIN}
    ```

10. Your certificate will now be under `./certs/live/<DOMAIN>/`.

## Self-signed

1. Set `DOMAIN` you want to create this certificate for in this terminal session:
    ```
    DOMAIN="example.com"
    ```

2. Create a directory for the files to land:
    ```
    mkdir -p certs
    mkdir -p certs/${DOMAIN}
    ```

3. Generate the certificate:
    ```
    openssl req -x509 -newkey rsa:2048 -nodes -keyout ./certs/${DOMAIN}/privkey.pem -out ./certs/${DOMAIN}/fullchain.pem -days 3650 -subj "/CN=${DOMAIN}" -addext "subjectAltName=DNS:${DOMAIN},DNS:www.${DOMAIN}"
    ```

4. Your certificate will now be under `./certs/<DOMAIN>`.
