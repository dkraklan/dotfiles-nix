#!/usr/bin/env bash
# SketchyBar sets $NAME to the item name when it calls this script.

# Use the second sample of `top` to avoid the stale first snapshot.
PERCENT="$(top -l 1 | grep "CPU usage" | awk '{print $3}' | sed 's/%//')"

sketchybar -m --set "$NAME" label="$PERCENT"
