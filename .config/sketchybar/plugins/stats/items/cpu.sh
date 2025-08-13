#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"

cpu=(
	background.padding_left=0
	label.font="$FONT:Heavy:12"
	label.color="$TEXT"
	icon="$CPU"
	icon.font="$FONT:Bold:16.0"
	icon.color="$BLUE"
	update_freq=15
	script="$PLUGIN_DIR/stats/scripts/cpu_percent.sh"
)

sketchybar --add item cpu.percent right \
	--set cpu.percent "${cpu[@]}"
