#!/bin/sh

envsubst < /root/config.json.tp > /usr/local/etc/v2ray/config.json

# Download and install V2Ray
mkdir /tmp/v2ray
curl -L -H "Cache-Control: no-cache" -o /tmp/v2ray/v2ray.zip https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip /tmp/v2ray/v2ray.zip -d /tmp/v2ray
install -m 755 /tmp/v2ray/v2ray /usr/local/bin/v2ray
install -m 755 /tmp/v2ray/v2ctl /usr/local/bin/v2ctl

# Remove temporary directory
rm -rf /tmp/v2ray

# V2Ray new configuration
install -d /usr/local/etc/v2ray

# Run
if [[ $TUNNEL_TOKEN ]]; then
echo 'has tunnel token, run cloudflared tunnel'
curl -L -H "Cache-Control: no-cache" -o /root/cloudflared https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64
chmod +x /root/cloudflared
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json & /root/cloudflared tunnel --no-autoupdate run --token $TUNNEL_TOKEN --protocol http2 --url localhost:$PORT
else
/usr/local/bin/v2ray -config /usr/local/etc/v2ray/config.json
fi
