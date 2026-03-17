#!/usr/bin/env bash
#
# Toggle the bluetooth popup in hyprland
#
# Requirements:
# - none
#

if hyprctl clients -j | jq -e '.[] | select(.class=="bluetooth-popup")' >/dev/null; then
  # hyprctl dispatch closewindow class:bluetooth-popup
  pkill -f 'kitty.*bluetooth-popup'
else
  kitty --class bluetooth-popup -e ~/.config/waybar/scripts/bluetooth.sh
fi

