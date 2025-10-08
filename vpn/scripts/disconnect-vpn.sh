#!/bin/bash

if pgrep openvpn >/dev/null; then
  echo "OpenVPN process detected. Disconnecting..."
  sudo pkill openvpn

  sleep 8

  if pgrep openvpn >/dev/null; then
    echo "OpenVPN process still running! Try running again or check logs."
    exit 1
  else
    echo "✅ Disconnected successfully."
  fi
else
  echo "No OpenVPN process found."
fi

