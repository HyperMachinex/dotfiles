#!/bin/bash

# Make executable: chmod +x ~/.config/hypr/scripts/wallpaper_selector.sh
# Wofi wallpaper selector

WALLPAPER_DIR="$HOME/Pictures/wallpaper"

# Wofi configuration for wallpaper selection
SELECTED=$(find "$WALLPAPER_DIR" -name "*.jpg" -o -name "*.png" | \
           xargs -I {} basename {} | \
           sort | \
           wofi --dmenu \
                --insensitive \
                --prompt "Select Wallpaper:" \
                --width 600 \
                --height 400 \
                --show dmenu \
                --allow-markup \
                --cache-file /dev/null)

if [[ -n "$SELECTED" ]]; then
    WALLPAPER_PATH="$WALLPAPER_DIR/$SELECTED"
    
    # Preload if not already loaded
    hyprctl hyprpaper preload "$WALLPAPER_PATH" 2>/dev/null
    
    # Set wallpaper
    hyprctl hyprpaper wallpaper ",$WALLPAPER_PATH"
    
    # Show notification
    notify-send "Wallpaper has changed." "$SELECTED" -t 2000
fi
