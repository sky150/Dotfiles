#!/usr/bin/env bash

# Rofi theme (reuse your powermenu theme or adjust)
dir="$HOME/.config/rofi/powermenu"
theme="style"

# Check Bluetooth status
bt_status=$(bluetoothctl show | grep "Powered: yes" && echo "on" || echo "off")

# Options
if [ "$bt_status" = "on" ]; then
    toggle="Turn Bluetooth Off"
else
    toggle="Turn Bluetooth On"
fi
scan="Scan for Devices"
devices="Connect to Device"
manager="Open Blueman Manager"

# Rofi command
rofi_cmd() {
    rofi -dmenu -p "Bluetooth" -theme "$dir/$theme.rasi"
}

# List paired devices
list_devices() {
    bluetoothctl devices | awk '{print $3}' | rofi_cmd -p "Select Device"
}

# Connect to selected device
connect_device() {
    selected=$(list_devices)
    if [ -n "$selected" ]; then
        device_mac=$(bluetoothctl devices | grep "$selected" | awk '{print $2}')
        if [ -n "$device_mac" ]; then
            bluetoothctl connect "$device_mac"
        fi
    fi
}

# Main menu
chosen=$(echo -e "$toggle\n$scan\n$devices\n$manager" | rofi_cmd)

# Actions
case "$chosen" in
    "Turn Bluetooth On")
        bluetoothctl power on
        ;;
    "Turn Bluetooth Off")
        bluetoothctl power off
        ;;
    "Scan for Devices")
        bluetoothctl scan on &
        sleep 5
        bluetoothctl scan off
        ;;
    "Connect to Device")
        connect_device
        ;;
    "Open Blueman Manager")
        blueman-manager
        ;;
esac
