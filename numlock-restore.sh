#!/bin/bash

# Global variables
STATE_FILE="/home/$USER/numlock_state.log"

# Save the current state of NumLock
save_numlock_state() {
    local state
    state=$(xset q | grep "Num Lock:" | awk '{print $8}')
    if [[ $state == "on" ]]; then
        printf "on\n" > "$STATE_FILE"
    else
        printf "off\n" > "$STATE_FILE"
    fi
}

# Restore the state of NumLock
restore_numlock_state() {
    local saved_state current_state
    if [[ -f $STATE_FILE ]]; then
        saved_state=$(<"$STATE_FILE")
        current_state=$(xset q | grep "Num Lock:" | awk '{print $8}')
        if [[ $saved_state == "on" && $current_state == "off" ]]; then
            xdotool key Num_Lock
        elif [[ $saved_state == "off" && $current_state == "on" ]]; then
            xdotool key Num_Lock
        fi
        rm $STATE_FILE
    fi
}

# Main function
main() {
    if [[ $1 == "save" ]]; then
        save_numlock_state
    elif [[ $1 == "restore" ]]; then
        restore_numlock_state
    else
        printf "Usage: %s {save|restore}\n" "$0" >&2
        return 1
    fi
}

main "$@"
