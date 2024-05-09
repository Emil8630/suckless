#!/bin/bash

options=("🔴 Shutdown" "🔄 Reboot" "🔒 Lock" "👤 Logout")
selected_option=$(printf '%s\n' "${options[@]}" | dmenu -i -p "Power Menu:")

case "$selected_option" in
    "🔴 Shutdown")
        shutdown now
        ;;
    "🔄 Reboot")
        reboot
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

