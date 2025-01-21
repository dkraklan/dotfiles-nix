#!/usr/bin/env bash

# Function to display help
help() {
    echo "Usage: $0 [SESSION_NAME] [-p PROJECT_DIR] [-h]"
    echo "  SESSION_NAME: Name of the tmux session."
    echo "  -p PROJECT_DIR:  Project directory for dev_layout."
    echo "  -h: Display this help message."
}

# Function to launch "work" layout
# work_layout() {
#   local DIR="$HOME/SynologyDrive/Path/ansible"
#
#   tmux new-session -d -s "$SESSION" -n ansible
#   tmux send-keys -t "$SESSION:ansible" "cd $DIR && nvim" C-m
#   tmux split-window -h -p 33  # Corrected line
#   tmux send-keys -t "$SESSION:ansible.2" "cd $DIR" C-m
#   tmux new-window -t "$SESSION:2" -n "other-window"
#   tmux attach-session -t "$SESSION"
# }
work_layout() {
    local DIR="$HOME/SynologyDrive/Path/ansible"

    tmux new-session -d -s "$SESSION" -n ansible
    tmux send-keys -t "$SESSION:ansible" "cd $DIR && nvim" C-m # Removed pane number
    tmux split-window -h -p 33 -t "$SESSION:ansible"
    tmux send-keys -t "$SESSION:ansible.1" "cd $DIR" C-m
    tmux new-window -t "$SESSION:2" -n "shell"
    tmux attach-session -t "$SESSION"
}
# Function to launch "dev" layout

dev_layout() {
    local DIR="$PROJECT_DIR"

    # Start the tmux session and create the first window
    tmux new-session -d -s "$SESSION" -n dev

    # Move to the project dir in pane 0
    tmux send-keys -t "$SESSION:dev" "cd $DIR" C-m
    ## check for poetry file and run poetry shell if it exists

    if [ -f "$DIR/pyproject.toml" ]; then
        # Launch poetry shell
        tmux send-keys -t "$SESSION:dev.0" "poetry run nvim" C-m
    else
        # Run nvim directly if no pyproject.toml
        tmux send-keys -t "$SESSION:dev.0" "cd $DIR && nvim" C-m
    fi

    # Check if docker-compose.yml exists and run Docker Compose in Pane 1
    if [ -f "$DIR/docker-compose.yml" ]; then
        tmux send-keys -t "$SESSION:dev.1" "docker-compose up" C-m
        # Split the window horizontally, making Pane 0 occupy 85% of the width
        tmux split-window -h -t "$SESSION:dev" # Pane 0 set to 85%, Pane 1 gets the remaining space

        # Run commands in Pane 1
        tmux send-keys -t "$SESSION:dev.1" "cd $DIR" C-m
        tmux send-keys -t "$SESSION:dev.1" "tmux resize-pane -x 80" C-m

    fi

    #Check if there is a docker compose file one directory up
    if [ -f "$DIR/../docker-compose.yml" ]; then
        tmux send-keys -t "$SESSION:dev.1" "cd .. && docker-compose up" C-m
        # Split the window horizontally, making Pane 0 occupy 85% of the width
        tmux split-window -h -t "$SESSION:dev" # Pane 0 set to 85%, Pane 1 gets the remaining space

        # Run commands in Pane 1
        tmux send-keys -t "$SESSION:dev.1" "cd $DIR" C-m
        tmux send-keys -t "$SESSION:dev.1" "tmux resize-pane -x 80" C-m

    fi

    # Add a second window for shell tasks
    # tmux new-window -t "$SESSION:2" -n "shell"

    # Attach to the session
    tmux attach-session -t "$SESSION"
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
    -p)
        PROJECT_DIR="$2"
        shift 2
        ;;
    -h)
        help
        exit 0
        ;;
    *)
        SESSION="$1"
        shift
        ;;
    esac
done

# Check if SESSION is set
if [ -z "$SESSION" ]; then
    echo "Error: SESSION_NAME is required."
    help
    exit 1
fi

# Determine which layout to launch based on session name
case "$SESSION" in
work)
    work_layout
    ;;
dev)
    dev_layout
    ;;
*)
    echo "Error: Invalid SESSION_NAME."
    help
    exit 1
    ;;
esac
