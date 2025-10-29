# Toolbox

This is just a simple Docker compose file to host Open Web UI and Ollama alongside a customized Kali Linux container routed through ProtonVPN (WireGuard).

## Usage

### Building Kali

Build the custom Kali image:

`$ ./build.sh`

### Root password and WireGuard configuration

Create a file called `.env` next to `docker-compose.yaml` and configure the following inside it:

```
ROOT_PASSWORD=<desired-root-password>
WIREGUARD_PRIVATE_KEY=<wireguard-private-key-from-any-config>
```

Various options for WireGuard can be found in `docker-compose.yaml`

### GPU

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

## Usage

### Run the stack

`$ docker compose up -d`

### Accessing Kali

`$ ssh root@localhost -p 6901`

### Accessing the shared directory

The host and the Kali machine share a directory at ./data/vault. If you experience issues with permissions when accessing it from the host, try using sudo.

## Troubleshooting

### VPN Crash

Kali's VPN connection is handled by Gluetun. If the VPN crashes, gets stuck in a loop, or otherwise has errors, try restarting the gluetun container:

`$ docker restart <gluetun_container_id>`
