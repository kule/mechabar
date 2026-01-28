#!/usr/bin/env bash

confirm() {
    printf "Yes\nNo" | wofi --dmenu --prompt "$1" --cache-file /dev/null | tr -d '\n'
}

choice=$(printf "  Lock\n  Logout\n  Reboot\n  Shutdown\n  Suspend" \
    | wofi --dmenu --prompt "Power" --cache-file /dev/null \
    | sed 's/^[^ ]*  //')


case "$choice" in
    "Lock")
        hyprlock
        ;;

    "Logout")
        if [ "$(confirm 'Logout?')" = "Yes" ]; then
            hyprctl dispatch exit
        fi
        ;;

    "Reboot")
        if [ "$(confirm 'Reboot?')" = "Yes" ]; then
            systemctl reboot
        fi
        ;;

    "Shutdown")
        if [ "$(confirm 'Shutdown?')" = "Yes" ]; then
            systemctl poweroff
        fi
        ;;

    "Suspend")
        if [ "$(confirm 'Suspend?')" = "Yes" ]; then
            systemctl suspend
        fi
        ;;
esac

