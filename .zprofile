# Start a UWSM-managed Hyprland session on TTY1
if uwsm check may-start; then
    exec uwsm start hyprland.desktop
fi

