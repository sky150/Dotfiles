#!/bin/bash

# Directory for wallpapers
TARGET_DIR="$HOME/Bilder/Wallpaper"

# Temporary file for yazi selection
TEMP_FILE=$(mktemp)

# Open yazi to select wallpaper
yazi --chooser-file "$TEMP_FILE" "$TARGET_DIR"

# Read selected wallpaper
WALLPAPER=$(cat "$TEMP_FILE")
rm "$TEMP_FILE"

# Check if valid
if [[ -z "$WALLPAPER" || ! -f "$WALLPAPER" ]]; then
    notify-send -t 5000 -a "Wallpaper" "No wallpaper selected" || true
    exit 0
fi

# Set wallpaper with swww
swww img "$WALLPAPER"

# Save wallpaper path for persistence
echo "$WALLPAPER" > ~/.cache/current-wallpaper

# Send notification
notify-send -t 5000 -a "Wallpaper" "Wallpaper Changed" -i "$WALLPAPER" || true
