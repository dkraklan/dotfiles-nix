#!/usr/bin/env bash

source "$HOME/.config/sketchybar/colors.sh"
source "$HOME/.config/sketchybar/icons.sh"

# render_bar_item() {
# 	if [ "$SSID" = "" ]; then
# 		args+=(--set "$NAME" label="N/A")
# 	else
# 		args+=(--set "$NAME" label="$SSID (${CURR_TX}Mbps)"
# 			label.drawing=off) # remove if you want more detailed info available without hovering
# 	fi
# }
#
# render_popup() {
# 	args+=(--set wifi.details label="$SSID ($CURR_TX Mbps)"
# 		click_script="sketchybar --set $NAME popup.drawing=off")
#
# 	sketchybar -m "${args[@]}" >/dev/null
#
# }
#
# update() {
# 	CURRENT_WIFI="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I)"
# 	SSID="$(echo "$CURRENT_WIFI" | grep -o "SSID: .*" | sed 's/^SSID: //')"
# 	CURR_TX="$(echo "$CURRENT_WIFI" | grep -o "lastTxRate: .*" | sed 's/^lastTxRate: //')"
# 	# read in out <<<$(ifstat -w -n -z -i en0 | awk 'NR>2 {print $1, $2}')
# 	# ifstat -w -S -n -z -i en0
#
# 	args=()
#
# 	render_bar_item
# 	render_popup
#
# 	if [ "$SENDER" = "forced" ]; then
# 		sketchybar --animate tanh 15 --set "$NAME" label.y_offset=5 label.y_offset=0
# 	fi
# }
#
# popup() {
# 	sketchybar --set "$NAME" popup.drawing="$1"
# }
#
# case "$SENDER" in
# "routine" | "forced")
# 	update
# 	;;
# "mouse.entered")
# 	popup on
# 	;;
# "mouse.exited" | "mouse.exited.global")
# 	popup off
# 	;;
# "mouse.clicked")
# 	popup toggle
# 	;;
# esac
#

# Get Wi-Fi network information
WI_FI_INFO=$(networksetup -listallhardwareports | awk '/Wi-Fi/{getline; print $2}')

# Get the current Wi-Fi network
#CURRENT_NETWORK=$(echo "$WI_FI_INFO" | xargs networksetup -getairportnetwork | sed "s/Current Wi-Fi Network: //")

CURRENT_NETWORK=$(echo "$WI_FI_INFO" | ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}')

# Check if the current network is associated with an airport network
if echo "$CURRENT_NETWORK" | grep -q "You are not associated with an AirPort network"; then
    LABEL="N/A"
    sketchybar --set wifi.alias background.color=0xff3C3E4F --set net label.color=0xff1e1d2e
else
    sketchybar --set wifi.alias label.color=0xffECEFF4 
    # Truncate the current network name if longer than 10 characters
    if [ "$(echo "$CURRENT_NETWORK" | awk '{ print length($1) }')" -gt 10 ]; then
        label=$(echo "$CURRENT_NETWORK" | awk '{ print substr($0, 1, 7) }')
        label=$(echo "$label" | sed 's/ *$//')
        LABEL="$label"...
    else
        LABEL=$(echo "$CURRENT_NETWORK" | awk '{ printf "%s", $1 }')
        # If there is a second word, print the first two characters followed by ...
        if [ "$(echo "$CURRENT_NETWORK" | awk '{ print NF }')" -gt 1 ]; then
            SECOND_WORD=$(echo "$CURRENT_NETWORK" | awk '{ printf "%s", substr($2, 1, 2) }')
            LABEL="$LABEL $SECOND_WORD..."
        fi
    fi
fi

sketchybar --set "$NAME" label="$LABEL"
