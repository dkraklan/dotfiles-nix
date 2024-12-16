#!/usr/bin/env bash

source $HOME/.config/sketchybar/colors.sh

if [ "$1" = "$FOCUSED_WORKSPACE" ]; then
    sketchybar --set $NAME background.drawing=on \
        background.color=$ROSEWATER\
        label.color=$BASE
else
    sketchybar --set $NAME background.drawing=off \
        label.color=$TEXT
fi
