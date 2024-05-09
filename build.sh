#!/bin/bash

# Script to build/rebuild all files

buildscript=$(pwd)
dwm="cd $buildscript/dwm"
dmenu="cd $buildscript/dmenu"
slock="cd $buildscript/slock"
st="cd $buildscript/st"

$dwm && sudo make clean install
$dmenu && sudo make clean install
$st && sudo make clean install
$slock && sudo make clean install

cd $buildscript && sudo cp linkhandler rssadd /usr/bin

echo -e "\033[32mDone!\033[0m"
