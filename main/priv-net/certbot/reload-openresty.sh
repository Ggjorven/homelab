#!/bin/sh

python3 -c "
import socket, sys

sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)
sock.connect('/var/run/docker.sock')
sock.send(b'POST /containers/openresty/kill?signal=SIGHUP HTTP/1.1\r\nHost: localhost\r\nContent-Length: 0\r\nConnection: close\r\n\r\n')
response = sock.recv(4096).decode()
sock.close()

# HTTP 204 means success
if '204' in response:
    print('[certbot] openresty reloaded successfully')
else:
    print('[certbot] unexpected response: ' + response.split('\r\n')[0])
    sys.exit(1)
" 2>/dev/null || echo '[certbot] openresty reload skipped (container not running)'
