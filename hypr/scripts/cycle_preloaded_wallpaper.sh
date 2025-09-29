#!/bin/bash

# Make executable: chmod +x ~/.config/hypr/scripts/cycle_preloaded_wallpaper.sh

# Cycle through ONLY preloaded wallpapers
WALLPAPER_DIR="$HOME/Pictures/wallpaper"
STATE_FILE="$HOME/.config/$USER/.current_preloaded_wallpaper"

# Get preloaded wallpapers from config
get_preloaded_wallpapers() {
    HYPRPAPER_CONFIG="$HOME/.config/$USER/hyprpaper.conf"
    if [[ -f "$HYPRPAPER_CONFIG" ]]; then
        grep "^preload" "$HYPRPAPER_CONFIG" | sed 's/preload = //' | sed 's|~/Pictures/wallpaper/||' | sed 's|$HOME/Pictures/wallpaper/||'
    fi
}

# Get array of preloaded wallpapers
mapfile -t PRELOADED_WALLPAPERS < <(get_preloaded_wallpapers)

if [[ ${#PRELOADED_WALLPAPERS[@]} -eq 0 ]]; then
    notify-send "Error" "No preloaded wallpaper" -t 3000
    exit 1
fi

# Get current index
if [[ -f "$STATE_FILE" ]]; then
    CURRENT_INDEX=$(cat "$STATE_FILE")
else
    CURRENT_INDEX=0
fi

# Calculate next index
NEXT_INDEX=$(( (CURRENT_INDEX + 1) % ${#PRELOADED_WALLPAPERS[@]} ))

# Get next wallpaper
NEXT_WALLPAPER="${PRELOADED_WALLPAPERS[$NEXT_INDEX]}"
WALLPAPER_PATH="$WALLPAPER_DIR/$NEXT_WALLPAPER"

# Check if wallpaper exists
if [[ -f "$WALLPAPER_PATH" ]]; then
    hyprctl hyprpaper wallpaper ",$WALLPAPER_PATH"
    echo "$NEXT_INDEX" > "$STATE_FILE"
    
    # Show notification with position
    TOTAL=${#PRELOADED_WALLPAPERS[@]}
    POSITION=$((NEXT_INDEX + 1))
    notify-send "🔄 Preloaded Wallpaper" "$NEXT_WALLPAPER ($POSITION/$TOTAL)" -t 2000
else
    notify-send "Error" "Wallpaper not found.: $NEXT_WALLPAPER" -t 3000
fi
