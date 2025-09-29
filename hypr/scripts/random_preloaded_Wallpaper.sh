#!/bin/bash

# Make executable: chmod +x ~/.config/hypr/scripts/random_preloaded_wallpaper.sh

WALLPAPER_DIR="$HOME/Pictures/wallpaper"

# Get preloaded wallpapers from config
get_preloaded_wallpapers() {
    HYPRPAPER_CONFIG="$HOME/.config/$USER/hyprpaper.conf"
    if [[ -f "$HYPRPAPER_CONFIG" ]]; then
        grep "^preload" "$HYPRPAPER_CONFIG" | sed 's/preload = //' | sed 's|~/Pictures/wallpaper/||' | sed 's|$HOME/Pictures/wallpaper/||'
    fi
}
