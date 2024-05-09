#!/bin/sh

# Display contents of clipboard via dunst if running.

! pgrep -x dunst >/dev/null && echo "dunst not running." && exit

clip=$(xclip -o -selection clipboard)

[ "$clip" != "" ] && notify-send "Clipboard:
$clip"
