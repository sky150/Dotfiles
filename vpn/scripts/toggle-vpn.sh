#!/bin/bash

CONFIG_PATH="$HOME/Dokumente/vpn_config"
LOGFILE="/tmp/openvpn.log"

if pgrep openvpn >/dev/null; then

  notify-send -i network-vpn "🔌 Disconnecting VPN..."
  sudo -n pkill openvpn
  sleep 8
  if pgrep openvpn >/dev/null; then
    notify-send -i network-vpn "⚠️  Failed to disconnect VPN"
    exit 1
  else
    notify-send -i network-vpn "✅ VPN disconnected"
    exit 0  
  fi
else
  cd "$CONFIG_PATH" || { notify-send "VPN" "❌ Path not found: $CONFIG_PATH"; exit 1; }

  configs=( *.ovpn )
  if [[ ${#configs[@]} -eq 0 ]]; then
    notify-send "VPN" "❌ No .ovpn files found in $CONFIG_PATH"
    exit 1
  fi

  server_name="${configs[RANDOM % ${#configs[@]}]}"
  notify-send -i network-vpn "🔐 Connecting to $server_name..."

  sudo -n openvpn --config "$server_name" > "$LOGFILE" 2>&1 &
  sleep 5

  if pgrep openvpn >/dev/null; then
    notify-send -i network-vpn "✅ Connected to $server_name"
    exit 0
  else
    notify-send -i network-vpn "❌ Connection failed"
    exit 1
  fi
fi

