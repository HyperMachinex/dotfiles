#!/bin/bash

# Power Menu Script for Waybar with Wofi
# Shows options for logout, reboot, shutdown, and sleep

# Show power menu with wofi
choice=$(echo -e "󰍃 Logout\n󰜉 Reboot\n󰐥 Shutdown\n󰒲 Sleep" | wofi --dmenu \
    --prompt "Power Menu" \
    --width=250 \
    --height=200 \
    --cache-file=/dev/null \
    --hide-scroll \
    --no-actions \
    --matching=contains \
    --insensitive)

# Execute the chosen action
case $choice in
    "󰍃 Logout")
        # For Hyprland
        if pgrep -x "Hyprland" > /dev/null; then
            hyprctl dispatch exit
        # For Sway
        elif pgrep -x "sway" > /dev/null; then
            swaymsg exit
        else
            # Generic logout
            loginctl terminate-session $XDG_SESSION_ID
        fi
        ;;
    "󰜉 Reboot")
        systemctl reboot
        ;;
    "󰐥 Shutdown")
        systemctl poweroff
        ;;
    "󰒲 Sleep")
        systemctl suspend
        ;;
    *)
        # Cancel or no selection - do nothing
        exit 0
        ;;
esac
