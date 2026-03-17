#!/usr/bin/env bash
#
# Toggle the network popup in hyprland
#
# Requirements:
# - none
#

if hyprctl clients -j | jq -e '.[] | select(.class=="network-popup")' >/dev/null; then
  # hyprctl dispatch closewindow class:network-popup
  pkill -f 'kitty.*network-popup'
else
  kitty --class network-popup -e ~/.config/waybar/scripts/network.sh
fi

