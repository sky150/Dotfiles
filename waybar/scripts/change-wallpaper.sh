#!/bin/bash

# Directory for wallpapers
TARGET="$HOME/Bilder/Wallpaper"

# Select random wallpaper
WALLPAPER=$(find "$TARGET" -type f -regex '.*\.\(jpg\|jpeg\|png\|webp\)' | shuf -n 1)

# Set wallpaper with swww
swww img "$WALLPAPER"

# Save wallpaper path for persistence
echo "$WALLPAPER" > ~/.cache/current-wallpaper

# Send notification
notify-send -t 5000 -a "Wallpaper" "Wallpaper Changed" -i "$WALLPAPER" || true
