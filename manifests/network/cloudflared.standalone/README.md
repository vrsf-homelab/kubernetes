```shell
k create secret generic test --from-file=cert.pem=$HOME/.cloudflared/cert.pem --output yaml --dry-run=client

k create secret generic test --from-file=credentials.json=$HOME/.cloudflared/$TUNNEL_ID.json --output yaml --dry-run=client
```
