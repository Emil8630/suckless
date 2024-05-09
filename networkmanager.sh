#!/bin/bash

# Function to list available Wi-Fi networks
list_wifi_networks() {
    nmcli -t -f SSID device wifi list | cut -d: -f2
}

# Function to connect to a selected Wi-Fi network
connect_to_wifi() {
    selected_ssid="$1"
    
    wifi_password=$(echo "" | dmenu -p "Enter the password for '$selected_ssid':")
    
    nmcli device wifi connect "$selected_ssid" password "$wifi_password"
}

# Main function
main() {
    selected_wifi=$(list_wifi_networks | dmenu -i -p "Select a Wi-Fi network:")

    if [ -n "$selected_wifi" ]; then
        connect_to_wifi "$selected_wifi"
    else
        echo "No Wi-Fi network selected."
    fi
}

main

