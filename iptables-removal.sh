#!/bin/bash

# Bash script for clearing up Archcraft for QEMU Installation from my installation script


# Define the directory path
directory="/usr/bin"

# Shred files with "iptables" in their names
find "$directory" -type f -name "*iptables*" -print0 | xargs -0 shred -n 5 -fzu

# Find directories with "iptables" in their names
find "$directory" -type d -name "*iptables*" -print0 | while IFS= read -r -d $'\0' dir; do
    # Shred files within the directory
    find "$dir" -type f -print0 | xargs -0 -I {} shred -n 5 -fzu {}
    
    # Remove the now-empty directory
    rmdir "$dir"
done

