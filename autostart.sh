#!/usr/bin/env bash

# Define the path to your script
BAR_PATH="/home/$USER/github/suckless/bar.sh"

# Kill already running processes
_ps=(picom dunst ksuperkey mpd xfce-polkit xfce4-power-manager "$BAR_PATH")
for _prs in "${_ps[@]}"; do
    if pidof "${_prs}" > /dev/null; then
        echo "Killing process: ${_prs}"
        killall -9 "${_prs}"
    fi
done


# Restore wallpaper
hsetroot -cover /home/less/github/wallpapers/gabriel-garcia-marengo-SpEQIUw7_TQ-unsplash.jpg 

usr=$(whoami)
dir=/home/$usr/github/suckless


# Start mpd
#exec mpd &

exec mullvad connect &
#exec xrandr --output HDMI-0 --rate 144 --mode 1920x1080 &
#exec xrandr --output HDMI3 --left-of HDMI-0 --mode 1920x1080 --rate 60 &
#exec xrandr --output VGA1 --right-of HDMI-0 --mode 1920x1080 --rate 60 &

exec xrandr --output DP-0 --primary --mode 1920x1080 --rate 143.85 &
#exec sleep 2
exec xrandr --output HDMI-0 --left-of DP-0 --mode 1920x1080 &
#exec sleep 2
exec xrandr --output DP-2 --right-of DP-0 --mode 1920x1080 --rate 165.00 &
# Random wall
exec "$dir/wall.sh" &
# Lauch dwmbar
#exec "$dir/bar.sh" &
exec "$dir/bar.sh" &

# Lauch notification daemon
exec "$dir/dunst.sh" &

# Lauch compositor
#exec "$dir/compositor.sh" &
exec "$dir/compositor.sh" &

# Fix Java problems
wmname "LG3D"
export _JAVA_AWT_WM_NONREPARENTING=1


exec "$dir/numlock-restore.sh restore" &

# Fix cursor
xsetroot -cursor_name left_ptr

# Polkit agent
/usr/lib/xfce-polkit/xfce-polkit &

# Enable power management
xfce4-power-manager &

transmission-daemon &


