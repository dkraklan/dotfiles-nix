#!/usr/bin/env zsh

#### Aerospace ####
sketchybar --add event aerospace_workspace_change

echo "aerospace item.sh"

divider=(
	background.color="$SURFACE0"
	background.border_color="$SURFACE1"
	background.border_width=2
	background.padding_left=5
	background.padding_right=10
)

# get_icon_for_app() {
#     case $1 in
#         "Microsoft Edge") icon="" ;;
#         "iTerm2") icon="" ;;
#         "Telegram") icon="" ;;
#         "Discord") icon="󰙯" ;;
#         "Slack") icon="" ;;
#         "DBeaver") icon="" ;;
#         *) icon="" ;;
#     esac
#     echo $icon
# }

for sid in $(aerospace list-workspaces --all); do
    # echo "sid: $sid"
    # icon=""
    # cur_windows=$(aerospace list-windows --workspace $sid --format "%{app-name}")

    # while IFS= read -r app; do
    #     echo "app: $app"
    #     icon+=$(get_icon_for_app "$app")
    #     # if we already have an icon, add a space
    #     if [ ! -z "$icon" ]; then
    #         icon+=" "
    #     fi
    #
    #     echo "icon: $icon"
    # done <<< "$cur_windows"

    # case $sid in 
    #     "1")
    #         icon=""
    #         ;;
    #     "2")
    #         icon="󰭹"
    #         ;;
    #     "3")
    #         icon=""
    #         ;;
    #     "5")
    #         icon=""
    #         ;;
    #     "6")
    #         icon="󰎚"
    #         ;;
    #     *)
    #         icon=""
    #         ;;
    # esac 

    sketchybar --add item space.$sid left \
        --subscribe space.$sid aerospace_workspace_change \
        --set space.$sid \
        background.color=0x44ffffff \
        background.corner_radius=5 \
        background.height=20 \
        background.drawing=off \
        label="$sid" \
        label.align=left \
        label.padding_right=8 \
        label.padding_left=0 \
        click_script="aerospace workspace $sid" \
        script="$PLUGIN_DIR/aerospace/scripts/aerospace.sh $sid" \
        # update_freq=1
done



sketchybar --add bracket spaces space.1 space.2 space.3 space.4 space.5 space.6 space.7 space.8 space.9 \
    --set spaces "${divider[@]}"
