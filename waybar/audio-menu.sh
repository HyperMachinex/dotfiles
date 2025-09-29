#!/bin/bash

# Audio Menu Script for Waybar with Wofi
# Shows audio control options

# Get current volume and mute status
current_volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print int($2*100)}')
mute_status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o "MUTED" || echo "")

if [ "$mute_status" = "MUTED" ]; then
    status_text="🔇 Muted ($current_volume%)"
else
    status_text="🔊 Volume: $current_volume%"
fi

# Show audio menu with wofi
choice=$(echo -e "🔇 Toggle Mute\n🔉 Volume 25%\n🔊 Volume 50%\n🔊 Volume 75%\n🔊 Volume 100%\n🎧 Audio Settings" | wofi --dmenu \
    --prompt "$status_text" \
    --width=250 \
    --height=220 \
    --cache-file=/dev/null \
    --hide-scroll \
    --no-actions \
    --matching=contains \
    --insensitive)

# Execute the chosen action
case $choice in
    "🔇 Toggle Mute")
        wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
        ;;
    "🔉 Volume 25%")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 25%
        ;;
    "🔊 Volume 50%")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 50%
        ;;
    "🔊 Volume 75%")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 75%
        ;;
    "🔊 Volume 100%")
        wpctl set-volume @DEFAULT_AUDIO_SINK@ 100%
        ;;
    "🎧 Audio Settings")
        # Try different audio control applications
        if command -v pavucontrol >/dev/null 2>&1; then
            pavucontrol
        elif command -v alsamixer >/dev/null 2>&1; then
            alacritty -e alsamixer
        elif command -v pulsemixer >/dev/null 2>&1; then
            alacritty -e pulsemixer
        else
            notify-send "No audio control app found" "Install pavucontrol, alsamixer, or pulsemixer"
        fi
        ;;
    *)
        # Cancel or no selection - do nothing
        exit 0
        ;;
esac
