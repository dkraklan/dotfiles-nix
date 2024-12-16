#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# Check if Tailscale is running
#
#

status=$($tailscale status)

if [ "$status" == "Tailscale is stopped." ]; then
    sketchybar --set "$NAME"\
                icon="󰛳"\
                icon.color="$RED"\
                icon.drawing=on
else
    sketchybar --set "$NAME"\
                icon="󰛳"\
                icon.color="$GREEN" \
                icon.drawing=on
fi
