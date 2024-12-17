#!/usr/bin/env bash

source $HOME/.config/sketchybar/colors.sh

echo "aerospace script"



get_icon_for_app() {
    case $1 in
        "Microsoft Edge") icon="" ;;
        "iTerm2") icon="" ;;
        "Telegram") icon="" ;;
        "Discord") icon="󰙯" ;;
        "Slack") icon="" ;;
        "DBeaver") icon="" ;;
        "Signal") icon="󰭹" ;;
        "Obsidian") icon="󱞁" ;;
        "Spotify") icon="" ;;
        *) icon="" ;;
    esac
    echo $icon
}

sid=$(echo "$NAME" | cut -d'.' -f2)

echo "updating aerospace $sid"

icon=""  # Initialize the icon variable as empty
cur_windows=$(aerospace list-windows --workspace $sid --format "%{app-name}")
echo "cur_windows: $cur_windows"

while IFS= read -r app; do
    echo "app: $app"
    app_icon=$(get_icon_for_app "$app")  # Fetch the icon for this app
    echo "found app icon: $app_icon" 
    if [ -n "$app_icon" ]; then  # Only add non-empty icons
        if [ -z "$icon" ]; then
            echo "first app icon: $app_icon"
            icon="$app_icon"  # First app, no space before the icon
        else
            echo "app icon: $app_icon"
            icon+=" $app_icon"  # Append with a space before each subsequent icon
        fi
    fi
done <<< "$cur_windows"

echo "icon: $icon"



if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on \
        background.color=$ROSEWATER\
        label.color=$BASE\
        icon.color=$BASE\
        icon="$icon" 
else
    sketchybar --set $NAME background.drawing=off \
        label.color=$SAPPHIRE\
        icon.color=$TEXT\
        icon="$icon" 

fi
