#!/usr/bin/env bash

## Copyright (C) 2020-2023 Aditya Shakya <adi1090x@gmail.com>
## Autostart Programs

# Kill already running process
_ps=(picom dunst ksuperkey mpd xfce-polkit xfce4-power-manager)
for _prs in "${_ps[@]}"; do
	if [[ `pidof ${_prs}` ]]; then
		killall -9 ${_prs}
	fi
done

# Fix cursor
xsetroot -cursor_name left_ptr

# Polkit agent
/usr/lib/xfce-polkit/xfce-polkit &

# Enable power management
xfce4-power-manager &

transmission-daemon &

# Enable Super Keys For Menu
ksuperkey -e 'Super_L=Alt_L|F1' &
ksuperkey -e 'Super_R=Alt_L|F1' &

# Restore wallpaper
hsetroot -cover /usr/share/archcraft/dwm/wallpapers/default.png

dir=$(pwd)

# Lauch dwmbar
#exec "$dir/bar.sh" &
exec "$dir/bar.sh" &

# Lauch notification daemon
exec "$dir/dunst.sh" &
#/home/less/dwm/dunst.sh &

# Lauch compositor
#exec "$dir/compositor.sh" &
exec "$dir/compositor.sh" &

# Start mpd
exec mpd &

exec mullvad connect &
#exec xrandr --output HDMI-0 --rate 144 --mode 1920x1080 &
#exec xrandr --output HDMI3 --left-of HDMI-0 --mode 1920x1080 --rate 60 &
#exec xrandr --output VGA1 --right-of HDMI-0 --mode 1920x1080 --rate 60 &

exec xrandr --output DP-0 --primary --mode 1920x1080 --rate 143.85 &
#exec sleep 2
exec xrandr --output HDMI-0 --left-of DP-0 --mode 1920x1080 &
#exec sleep 2
exec xrandr --output HDMI3 --right-of DP-0 --mode 1920x1080 &

exec variety -n &
#exec nitrogen --restore &


# Fix Java problems
wmname "LG3D"
export _JAVA_AWT_WM_NONREPARENTING=1

## Add your autostart programs here --------------

## -----------------------------------------------
# Launch DWM

#while dwm; [ $? -ne 0  ]; do echo "start dwm"; done


