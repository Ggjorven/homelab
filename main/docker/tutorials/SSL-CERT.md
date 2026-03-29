# SSL Cert

There are multiple ways to convert a HTTP website to an HTTPS site. All methods require an SSL certificate. This file contains multiple tutorials for getting SSL certificates.

## Let's encrypt (Recommended)

1. TODO

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
