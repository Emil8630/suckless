#!/usr/bin/env bash

## Launch dunst daemon
if [[ `pidof dunst` ]]; then
	pkill dunst
fi

dunstscript=$(readlink -f "$0")
dir=${buildfile::-10}
dunst -config dunstrc &
