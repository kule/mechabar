#!/usr/bin/env bash
#
# Toggle the system monitor popup in hyprland
#
# Requirements:
# - btop
#

if hyprctl clients -j | jq -e '.[] | select(.class=="btop-popup")' >/dev/null; then
  # hyprctl dispatch closewindow class:wiremix-popup
  pkill -f 'kitty.*btop'
else
  kitty --class btop-popup -e btop
fi

