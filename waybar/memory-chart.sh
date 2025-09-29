#!/bin/bash

# Memory Chart Script for Waybar
# Creates a visual bar chart representation of memory usage

# Get memory information
mem_info=$(free -m)
total=$(echo "$mem_info" | awk 'NR==2{print $2}')
used=$(echo "$mem_info" | awk 'NR==2{print $3}')
available=$(echo "$mem_info" | awk 'NR==2{print $7}')

# Calculate percentage
percentage=$((used * 100 / total))

# Create visual bar chart using Unicode block characters
# ▁ ▂ ▃ ▄ ▅ ▆ ▇ █
create_bar() {
    local percent=$1
    local bar_length=8
    local filled=$((percent * bar_length / 100))
    local bar=""
    
    # Full blocks
    for ((i=0; i<filled; i++)); do
        bar+="█"
    done
    
    # Partial block based on remainder
    local remainder=$((percent * bar_length % 100))
    if [ $filled -lt $bar_length ]; then
        if [ $remainder -ge 87 ]; then
            bar+="▇"
        elif [ $remainder -ge 75 ]; then
            bar+="▆"
        elif [ $remainder -ge 62 ]; then
            bar+="▅"
        elif [ $remainder -ge 50 ]; then
            bar+="▄"
        elif [ $remainder -ge 37 ]; then
            bar+="▃"
        elif [ $remainder -ge 25 ]; then
            bar+="▂"
        elif [ $remainder -ge 12 ]; then
            bar+="▁"
        fi
        filled=$((filled + 1))
    fi
    
    # Empty blocks
    for ((i=filled; i<bar_length; i++)); do
        bar+=" "
    done
    
    echo "$bar"
}

# Generate the visual bar
bar=$(create_bar $percentage)

# Color coding based on usage level
if [ $percentage -gt 90 ]; then
    color_class="critical"
    icon="🔴"
elif [ $percentage -gt 75 ]; then
    color_class="warning"
    icon="🟡"
else
    color_class="normal"
    icon="🟢"
fi

# Format output for Waybar
# The bar chart with percentage and icon
output="$icon [$bar]"

# Tooltip information
tooltip="Memory Usage: ${used}MB / ${total}MB (${percentage}%)"

# Output for Waybar (JSON format for rich tooltip support)
echo "$output $tooltip"
