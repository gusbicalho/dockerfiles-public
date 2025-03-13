FROM searxng/searxng

RUN mkdir -p /usr/local/mcp-searxng
WORKDIR /usr/local/mcp-searxng
COPY . .

RUN chmod +x entrypoint.sh

RUN python3 -m venv ./venv
RUN . ./venv/bin/activate && pip install uv && uv venv --python 3.12 && uv tool install mcp-searxng

ENTRYPOINT [ "sh", "/usr/local/mcp-searxng/entrypoint.sh" ]
