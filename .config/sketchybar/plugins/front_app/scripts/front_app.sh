#!/bin/sh

# Some events send additional information specific to the event in the $INFO
# variable. E.g. the front_app_switched event sends the name of the newly
# focused application in the $INFO variable:
# https://felixkratz.github.io/SketchyBar/config/events#events-and-scripting



if [ "$SENDER" = "front_app_switched" ]; then
    case $INFO in
        "Discord")
            ICON="" # Discord logo
            ;;
        "Microsoft Edge")
            ICON="" # Edge browser logo
            ;;
        "Obsidian")
            ICON="" # Note-taking icon
            ;;
        "Signal")
            ICON="" # Signal app (phone-like icon)
            ;;
        "Slack")
            ICON="" # Slack logo
            ;;
        "iTerm2")
            ICON="" # Terminal icon
            ;;
        *)
            ICON="" # Default generic circle icon
            ;;
    esac

    sketchybar --set "$NAME" label="$INFO" \
        icon="$ICON"
fi

