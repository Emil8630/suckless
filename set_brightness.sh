#!/bin/bash

BACKLIGHT_PATH="/sys/class/backlight/intel_backlight"  # Change this if necessary
MAX_BRIGHTNESS=$(cat "$BACKLIGHT_PATH/max_brightness")
CURRENT_BRIGHTNESS=$(cat "$BACKLIGHT_PATH/brightness")

case "$1" in
    up)
        NEW_BRIGHTNESS=$((CURRENT_BRIGHTNESS + (MAX_BRIGHTNESS / 10)))  # Increase by 10%
        ;;
    down)
        NEW_BRIGHTNESS=$((CURRENT_BRIGHTNESS - (MAX_BRIGHTNESS / 10)))  # Decrease by 10%
        ;;
    set)
        NEW_BRIGHTNESS="$2"  # Set to a specific value
        ;;
    *)
        echo "Usage: $0 {up|down|set <value>}"
        exit 1
        ;;
esac

# Ensure the new brightness is within the valid range
if [ "$NEW_BRIGHTNESS" -lt 0 ]; then
    NEW_BRIGHTNESS=0
elif [ "$NEW_BRIGHTNESS" -gt "$MAX_BRIGHTNESS" ]; then
    NEW_BRIGHTNESS="$MAX_BRIGHTNESS"
fi

# Use pkexec to write the new brightness value
echo "$NEW_BRIGHTNESS" | pkexec tee "$BACKLIGHT_PATH/brightness" > /dev/null

