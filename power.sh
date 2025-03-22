#!/bin/bash

options=("🔴 Shutdown" "🔄 Reboot" "🔒 Lock" "👤 Logout")
selected_option=$(printf '%s\n' "${options[@]}" | dmenu -i -p "Power Menu:")

dir=$(pwd)

case "$selected_option" in
    "🔴 Shutdown")
        sh $dir/numlock-restore save
        shutdown now
        ;;
    "🔄 Reboot")
        sh $dir/numlock-restore save
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

