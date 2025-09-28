#!/bin/bash

# Send "Starting checkup..." notification
notify-send -t 2000 "Updates" "Starting checkup..." || true

# Output "Checking..." for Waybar
echo '{"text": "Checking...", "tooltip": "Checking for updates..."}'

# Check pacman updates
PACMAN_UPDATES=$(checkupdates | wc -l 2>/dev/null || echo 0)

sleep 30s

# Check AUR updates (using yay if available, or aur if yay is not installed)
if command -v yay >/dev/null; then
    AUR_UPDATES=$(yay -Qu | wc -l 2>/dev/null || echo 0)
else
    AUR_UPDATES=$(pacman -Qm | aur vercmp | wc -l 2>/dev/null || echo 0)
fi

sleep 15s

# Total updates
TOTAL_UPDATES=$((PACMAN_UPDATES + AUR_UPDATES))

# Send final notification
notify-send -t 5000 "Updates" "$TOTAL_UPDATES updates available (Pacman: $PACMAN_UPDATES, AUR: $AUR_UPDATES)" || true

# Output JSON for Waybar
echo "{\"text\": \"$TOTAL_UPDATES\", \"tooltip\": \"$TOTAL_UPDATES updates available (Pacman: $PACMAN_UPDATES, AUR: $AUR_UPDATES)\"}"
