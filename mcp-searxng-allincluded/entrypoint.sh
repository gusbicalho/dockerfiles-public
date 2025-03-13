#! /bin/bash

/usr/local/searxng/dockerfiles/docker-entrypoint.sh -d >/var/log/searxng.log

awk '/^[[:space:]]*formats:$/{format_line=$0; getline; if($0 ~ /^[[:space:]]*- html$/){indent=$0; gsub(/- html$/,"",indent); print indent "formats: [html, json]"; next}} {print}' /etc/searxng/settings.yml >/tmp/settings.yml

mv /tmp/settings.yml /etc/searxng/settings.yml

nohup /usr/local/searxng/dockerfiles/docker-entrypoint.sh >/var/log/searxng.log &

cd /usr/local/mcp-searxng
source ./venv/bin/activate
uv tool run mcp-searxng
