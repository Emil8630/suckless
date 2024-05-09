#!/bin/bash
program=$(dmenu_path | dmenu -p "Run without VPN:") && mullvad-exclude "$program"

