#!/usr/bin/env bash
#
# Toggle the audio mixer popup in hyprland
#
# Requirements:
# - wiremix
#

if hyprctl clients -j | jq -e '.[] | select(.class=="wiremix-popup")' >/dev/null; then
  # hyprctl dispatch closewindow class:wiremix-popup
  pkill -f 'kitty.*wiremix'
else
  kitty --class wiremix-popup -e wiremix
fi

