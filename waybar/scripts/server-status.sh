#!/bin/bash

# Server status check script for Waybar
# Place this in ~/.config/waybar/scripts/server-status.sh

SERVER_IP="192.168.1.51"
SERVER_PORT="8006"
TIMEOUT=3

# Check if server is reachable
if timeout $TIMEOUT bash -c "echo >/dev/tcp/$SERVER_IP/$SERVER_PORT" 2>/dev/null; then
    # Server is up
    echo '{"text": "󰒋", "tooltip": "Homeserver: Online ('"$SERVER_IP"')", "class": "server-up"}'
else
    # Server is down
    echo '{"text": "󰒎", "tooltip": "Homeserver: Offline ('"$SERVER_IP"')", "class": "server-down"}'
fi
