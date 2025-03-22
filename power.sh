#!/bin/bash

options=("🔴 Shutdown" "🔄 Reboot" "🌙 Sleep" "🔒 Lock" "👤 Logout")
selected_option=$(printf '%s\n' "${options[@]}" | dmenu -i -p "Power Menu:")

dir="/home/$USER/github/suckless"

case "$selected_option" in
    "🔴 Shutdown")
        sh "$dir/numlock-restore.sh save"
        shutdown now
        ;;
    "🔄 Reboot")
        sh "$dir/numlock-restore.sh save"
        reboot
        ;;
    "🌙 Sleep")
        systemctl suspend 
        ;;
    "👤 Logout")
        pkill -u "$USER"
        ;;
    "🔒 Lock")
        slock -m "The screen is locked"
        #betterlockscreen -q -l 
        ;;
    *)
        echo "Invalid option"
        ;;
esac

