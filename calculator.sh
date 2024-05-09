#!/bin/bash

# Prompt the user for an arithmetic expression
expression=$(echo "" | dmenu -p "Enter an equation:")

# Calculate the result using bc
result=$(echo "$expression" | bc)

# Copy the result to the clipboard using xclip
echo -n "$result" | xclip -selection clipboard

# Display the result using dmenu and as a notification
notify-send "Result" "$expression = $result"

