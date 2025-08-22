#!/usr/bin/env bash
# SketchyBar sets $NAME to the item name when it calls this script.

# Use the second sample of `top` to avoid the stale first snapshot.
PERCENT="$(sysctl -n vm.loadavg | awk '{print $2}')"

sketchybar -m --set "$NAME" label="$PERCENT"
