#!/bin/bash

# Make executable: chmod +x ~/.config/hypr/scripts/preloaded_wallpaper_selector.sh

WALLPAPER_DIR="$HOME/Pictures/wallpaper"

# Get list of preloaded wallpapers from hyprpaper
get_preloaded_wallpapers() {
    # Get preloaded wallpapers from hyprctl
    hyprctl hyprpaper listloaded 2>/dev/null | grep -E "^preload" | sed 's/preload = //' | xargs -I {} basename {}
}

# Alternative method: Read from hyprpaper config
get_preloaded_from_config() {
    HYPRPAPER_CONFIG="$HOME/.config/$USER/hyprpaper.conf"
    if [[ -f "$HYPRPAPER_CONFIG" ]]; then
        grep "^preload" "$HYPRPAPER_CONFIG" | sed 's/preload = //' | sed 's|~/Pictures/wallpaper/||' | sed 's|$HOME/Pictures/wallpaper/||'
    fi
}

# Function to get currently active wallpaper
get_current_wallpaper() {
    hyprctl hyprpaper listactive 2>/dev/null | head -1 | awk '{print $NF}' | xargs basename
}

# Main selector function
main() {
    # Try to get preloaded wallpapers from hyprctl first
    PRELOADED=$(get_preloaded_wallpapers)
    
    # If hyprctl doesn't work, fallback to config file
    if [[ -z "$PRELOADED" ]]; then
        PRELOADED=$(get_preloaded_from_config)
    fi
    
    if [[ -z "$PRELOADED" ]]; then
        notify-send "Hata" "No preloaded wallpaper." -t 3000
        exit 1
    fi
    
    # Get current wallpaper to highlight it
    CURRENT=$(get_current_wallpaper)
    
    # Create formatted list with current wallpaper marked
    FORMATTED_LIST=""
    while IFS= read -r wallpaper; do
        if [[ "$wallpaper" == "$CURRENT" ]]; then
            FORMATTED_LIST+="🎯 $wallpaper (Active)\n"
        else
            FORMATTED_LIST+="📷 $wallpaper\n"
        fi
    done <<< "$PRELOADED"
    
    # Show selection with wofi
    SELECTED=$(echo -e "$FORMATTED_LIST" | wofi --dmenu \
        --insensitive \
        --prompt "Select Preloaded Wallpaper:" \
        --width 500 \
        --height 300 \
        --cache-file /dev/null)
    
    if [[ -n "$SELECTED" ]]; then
        # Extract filename from formatted string
        WALLPAPER_NAME=$(echo "$SELECTED" | sed 's/^[🎯📷] //' | sed 's/ (Active)$//')
        WALLPAPER_PATH="$WALLPAPER_DIR/$WALLPAPER_NAME"
        
        # Set wallpaper (no need to preload since it's already preloaded)
        hyprctl hyprpaper wallpaper ",$WALLPAPER_PATH"
        
        # Show notification
        notify-send "🖼️ Wallpaper has changed." "$WALLPAPER_NAME" -t 2000
    fi
}

main
