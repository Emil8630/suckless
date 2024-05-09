#!/bin/bash

directory="/var/log"
#directory="/home/less/fakelogs"

# Check if the directory exists
if [ ! -d "$directory" ]; then
  echo "Directory does not exist."
  exit 1
fi

# Function to generate a random number
generate_random_number() {
  length="$1"
  echo $(cat /dev/urandom | tr -dc '0-9' | head -c "$length")
}

# Function to recursively shred files and directories in a directory
shred_files_and_directories() {
  local dir="$1"
  for item in "$dir"/*; do
    if [ -d "$item" ]; then
      # If it's a directory, recursively shred its contents
      shred_files_and_directories "$item"
      # Generate a random number and rename the directory
      new_name="$(generate_random_number ${#dir})"
      sudo mv "$item" "$dir/$new_name"
      # Delete the renamed directory
      sudo rmdir "$dir/$new_name"
    else
      # If it's a file, shred it
      sudo shred -fuz "$item"
    fi
  done
}

# Recursively shred files and directories inside /var/log
shred_files_and_directories "$directory"

echo "Files inside directories in /var/log have been shredded, and directories have been renamed and deleted."
