#!/usr/bin/env bash
#
# Fedora Waybar update checker using dnf
#
# Behaves like the Arch version:
# - "module" → output JSON for Waybar
# - default → check updates, upgrade, notify
#
# Requirements:
# - dnf
# - notify-send (libnotify)
#
# Author: adapted for Fedora

TIMEOUT=10
FAILURE=false
DNF_UPD=0

cprintf() {
    case $1 in
        green) printf "\e[32m" ;;
        blue)  printf "\e[34m" ;;
    esac
    printf "%b%b\n" "${@:2}" "\e[39m" >&2
}

check_updates() {
    local dnf_output dnf_status

    # dnf check-update returns:
    # 0 = no updates
    # 100 = updates available
    # 1 = error
    dnf_output=$(timeout $TIMEOUT dnf check-update 2>/dev/null)
    dnf_status=$?

    if (( dnf_status == 1 )); then
        FAILURE=true
        return 1
    fi

    # Count update lines (skip headers)
    DNF_UPD=$(echo "$dnf_output" | awk '/^\S/ {count++} END {print count+0}')
}

update_packages() {
    cprintf blue "Updating Fedora packages..."
    sudo dnf upgrade -y

    notify-send "Update Complete" -i "software-update-available"

    cprintf green "\nUpdate Complete!"
    read -rsn 1 -p "Press any key to exit..."
}

display_module() {
    if $FAILURE; then
        echo "{ \"text\": \"\", \"tooltip\": \"Cannot fetch updates. Right-click to retry.\" }"
        exit 0
    fi

    local tooltip="<b>Fedora</b>: $DNF_UPD"

    if (( DNF_UPD == 0 )); then
        echo "{ \"text\": \"\", \"tooltip\": \"No updates available\" }"
    else
        echo "{ \"text\": \"\", \"tooltip\": \"$tooltip\" }"
    fi
}

main() {
    case $1 in
        "module")
            check_updates
            display_module
            ;;
        *)
            cprintf blue "Checking for updates..."
            check_updates
            update_packages
            pkill -RTMIN+1 waybar
            ;;
    esac
}

main "$@"

