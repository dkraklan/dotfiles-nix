
#### Aerospace ####
sketchybar --add event aerospace_workspace_change
divider=(
	background.color="$SURFACE0"
	background.border_color="$SURFACE1"
	background.border_width=2
	background.padding_left=5
	background.padding_right=10
)
for sid in $(aerospace list-workspaces --all); do
    sketchybar --add item space.$sid left \
        --subscribe space.$sid aerospace_workspace_change \
        --set space.$sid \
        background.color=0x44ffffff \
        background.corner_radius=5 \
        background.height=20 \
        background.drawing=off \
        label="$sid" \
        label.padding_right=8 \
        label.padding_left=0 \
        click_script="aerospace workspace $sid" \
        script="$PLUGIN_DIR/aerospace/scripts/aerospace.sh $sid"


done


sketchybar --add bracket spaces space.1 space.2 space.3 space.4 space.5 space.6 space.7 space.8 space.9 \
    --set spaces "${divider[@]}"
