# Toolbox

This is just a simple Docker compose file to host Open Web UI and Ollama alongside a customized Kali Linux container routed through ProtonVPN (WireGuard).

# Usage

Build the custom Kali image:

`$ ./build.sh`

Create a file called `.env` next to `docker-compose.yaml` and configure the following inside it:

```
ROOT_PASSWORD=
WIREGUARD_PRIVATE_KEY=
```

If you are not running a dedicated NVIDIA GPU, remove the following from the Ollama service in `docker-compose.yaml`:

```
deploy:
    resources:
        reservations:
            devices:
                - driver: nvidia
                count: all
                capabilities: [gpu]
runtime: nvidia
```

Run the stack:

Running: `$ docker compose up`
