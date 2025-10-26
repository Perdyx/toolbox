#!/bin/bash

set -e

# Set root password
echo "root:${ROOT_PASSWORD}" | chpasswd

# Start SSH
exec /usr/sbin/sshd -D
