#!/usr/bin/env bash


POPUP_CLICK_SCRIPT="sketchybar --set $NAME popup.drawing=toggle"

tailscale=(
	icon.drawing=on
	background.padding_right=0
	icon.padding_right=5
    icon="󰛳"
    icon.color="$YELLOW"
	align=right
	# click_script="$POPUP_CLICK_SCRIPT"
	script="$PLUGIN_DIR/tailscale/scripts/tailscale.sh"
	update_freq=1
)

sketchybar --add item  tailscale right                      \
           --set        tailscale    "${tailscale[@]}"                 \
           # --subscribe  tailscale    mouse.entered                      \
           #                            mouse.exited                       \
           #                            mouse.exited.global                \
                                                                         \
            # --add       item          tailscale.details popup.tailscale      \
            # --set       tailscale.details  "${tailscale_details[@]}"
