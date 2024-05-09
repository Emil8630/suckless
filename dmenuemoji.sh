#!/bin/sh
# Grabs emoji out of emoji file based on the name given as input.

script_dir=$(dirname "$0")

grep -v "#" $script_dir/.lists/emoji | dmenu -i -p "Search:" -l 20 -fn Monospace-10 | awk '{print $1}' | tr -d '\n' | xclip -selection clipboard
    
pgrep -x dunst >/dev/null && notify-send "$(xclip -o -selection clipboard) has been copied to clipboard."

