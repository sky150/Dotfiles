#!/bin/bash
sudo pkill openvpn
pkill_status=$?
if [[ $pkill_status -eq 1 ]]; then
  echo "There is no process running. pkill openvpn: exit code $pkill_status"
fi
 
read -p "Enter path to the configuration files: " config_path
echo "Path to config: $config_path!"

echo "Current public ip :"
curl -4 ifconfig.me
echo

if [[ -n "$config_path" ]]; then
  cd $config_path
  config=( *.ovpn )

  if [[ ${#config[@]} -eq 0 ]]; then
    echo "There are no config files."
    exit 1
  fi

  if [[ -n "$config" ]]; then
    echo "Servers: "
    for i in "${!config[@]}"; do
      printf "%2d) %s\n" $((i)) "${config[$i]}"
    done

    read -p "Select a server number: " num 
    server_name="${config[$((num))]}"

    if [[ -z "$server_name" ]]; then
      echo "Invalid server"
      exit 1
    fi

    echo "Connecting to $server_name..."
    sudo openvpn --config $server_name > /tmp/openvpn.log 2>&1 &

    sleep 5

    vpn_pid=$!
    echo "✅ Connected to $server_name"
    echo "Current public ip :"
    curl -4 ifconfig.me
  else
    echo "There are no config files."
    exit 1
  fi
fi
