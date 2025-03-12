#! /bin/bash

mkdir -p /tmp/searxng;
cd /tmp/searxng;

cat << EOF > docker-compose.yml
services:
  x-searxng:
    container_name: x-searxng
    build:
      context: .
      dockerfile_inline: |
        FROM searxng/searxng
    volumes:
      - ./searxng-data:/etc/searxng
    environment:
      - BASE_URL=http://localhost:8080/
      - INSTANCE_NAME=gus-searxng
    restart: unless-stopped

  x-mcp-service:
    container_name: x-mcp-searxng
    build:
      context: .
      dockerfile_inline: |
        FROM python:3.9-slim
        RUN pip install uv
        RUN uv tool install mcp-searxng
        ENV SEARXNG_URL http://x-searxng:8080
    environment:
      - SEARXNG_URL=http://x-searxng:8080
    depends_on:
      - x-searxng
    restart: unless-stopped
    tty: true
    stdin_open: true
EOF

docker-compose down;
docker-compose up -d;
docker exec x-searxng sh -c 'awk '"'"'/^[[:space:]]*formats:$/{format_line=$0; getline; if($0 ~ /^[[:space:]]*- html$/){indent=$0; gsub(/- html$/,"",indent); print indent "formats: [html, json]"; next}} {print}'"'"' /etc/searxng/settings.yml > /tmp/settings.yml; mv /tmp/settings.yml /etc/searxng/settings.yml'
docker exec -i x-mcp-searxng uv tool run mcp-searxng
