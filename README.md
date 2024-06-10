



To reload nginx, run:

```bash
$ docker exec nginx-with-certbot \ # Run inside Docker container
  nginx -s reload # Reload nginx
```

To request a new certificate, run:

```bash
$ docker exec nginx-with-certbot \ # Run inside Docker container
  certbot --nginx --non-interactive --agree-tos -m webmaster@google.com -d plex.myserver.com # Get HTTPS certificate
```

## Building

```bash
$ docker buildx build  --platform linux/amd64,linux/arm64  --tag cometurrata/nginx-with-certbot-for-wireguard-easy . --push
```
