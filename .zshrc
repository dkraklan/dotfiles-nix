# I set these options on mac to avoid an issue with sourcing
if [[ "$(uname)" == "Darwin" ]]; then
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
fi



if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export ZSH="$HOME/.oh-my-zsh"

if [[ "$(uname)" != "Darwin" ]]; then

    ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

    # Ensure OMZ paths are set
    export ZSH="${ZSH:-$HOME/.oh-my-zsh}"
    export ZSH_CUSTOM="${ZSH_CUSTOM:-$ZSH/custom}"

    # Symlink AUR-installed plugins into OMZ custom/plugins if not present
    if [[ ! -e "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" && -e "/usr/share/zsh/plugins/zsh-syntax-highlighting" ]]; then
    ln -s /usr/share/zsh/plugins/zsh-syntax-highlighting \
        "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
    fi

    if [[ ! -e "$ZSH_CUSTOM/plugins/zsh-autocomplete" && -e "/usr/share/zsh/plugins/zsh-autocomplete" ]]; then
    ln -s /usr/share/zsh/plugins/zsh-autocomplete \
        "$ZSH_CUSTOM/plugins/zsh-autocomplete"
    fi

    # Let OMZ load them; do NOT manually `source` these files.
    plugins=(
    git
    poetry-env
    zsh-autocomplete
    docker
    rust
    kubectl
    zsh-syntax-highlighting  # keep this LAST
    )


    export PATH="/home/dkraklan/.local/bin:$PATH"

    ## Go
    if [[ -e "~/go" ]]; then
	export GOPATH=~/go
	export PATH=$GOPATH/bin:$PATH
    fi

    ## Godot 
    if [[ -e "/home/dkraklan/Desktop/Godot_Versions" ]]; then
	export PATH="/home/dkraklan/Desktop/Godot_Versions:$PATH"
    fi

    ## Linuxbrew 
    if [[ -e "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
	
    ## use the latest make version 
    if [[ -e "/opt/make-4.4/bin" ]]; then
	export PATH="/opt/make-4.4/bin:$PATH"
    fi

    ## Starship.rs
    if command -v starship &> /dev/null; then
        eval "$(starship init zsh)"
    fi

    if command -v direnv &> /dev/null; then
        eval "$(direnv hook zsh)"
    fi

else
    #Macos config
    source $(brew --prefix)/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    source $(brew --prefix zsh-autosuggestions)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    eval "$(zoxide init zsh)"
    ZSH_THEME="powerlevel10k/powerlevel10k"
    ssh-add .ssh/dylan_id_ed25519
    ssh-add .ssh/id_github_ed25519
    plugins=(
        git
        docker
        # poetry-env
        # zsh-autosuggestions
    )
	alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
	alias pathssh="~/.scripts/path_ssh_proxy.sh"
	alias dirgrep="~/.scripts/dirgrep.sh"
	alias pathdb="~/.scripts/db_proxy.sh"
	alias catclip="~/.scripts/catclip.sh"
	alias sslexpire="~/.scripts/sslexpire.sh"
	alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
    alias tl="/Users/dkraklan/.config/scripts/tmux_launch.sh"
	export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
    export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
	export PATH=/opt/homebrew/bin:$PATH
	alias python=python3

	function gam() { "/Users/dkraklan/bin/gam/gam" "$@" ; }
  
	eval "$(starship init zsh)"


fi


alias dockps="sudo docker ps --format 'table {{.Names}}\t{{.Status}}'"

DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

HIST_STAMPS="mm/dd/yyyy"

# Enhanced SSH function with better argument parsing
ssh() {
    if [[ -n "$TMUX" ]]; then
        local hostname=""
        local -a ssh_args=("$@")
        
        # Parse SSH arguments to find hostname
        local i=1
        while [[ $i -le ${#ssh_args[@]} ]]; do
            case "${ssh_args[$i]}" in
                -[1246AaCfGgKkMNnqsTtVvXxYy])
                    # Options without arguments
                    ;;
                -[bcDEeFIiJLlmOopQRSWw])
                    # Options with arguments, skip next argument too
                    ((i++))
                    ;;
                -*)
                    # Other options, might have arguments
                    if [[ "${ssh_args[$i]}" == *"="* ]]; then
                        # Option with = format (-oOption=value)
                        continue
                    fi
                    ;;
                *)
                    # This should be the hostname
                    hostname="${ssh_args[$i]}"
                    break
                    ;;
            esac
            ((i++))
        done
        
        # Clean up hostname (remove user@ part, port, etc.)
        hostname="${hostname##*@}"  # Remove user@
        hostname="${hostname%%:*}"  # Remove :port
        
        if [[ -n "$hostname" ]]; then
            # Store original window name
            local original_name=$(tmux display-message -p '#W')
            
            # Set window name to hostname
            tmux rename-window "$hostname"
            
            # Execute SSH
            command ssh "$@"
            
            # Restore original name when SSH exits
            tmux rename-window "$original_name"
        else
            # Couldn't parse hostname, just run SSH
            command ssh "$@"
        fi
    else
        # Not in tmux, just run regular SSH
        command ssh "$@"
    fi
}

source $ZSH/oh-my-zsh.sh

HISTFILE="$HOME/.zsh_history"
HISTSIZE=500000
SAVEHIST=500000
setopt appendhistory
setopt INC_APPEND_HISTORY  
setopt SHARE_HISTORY #Keybindings
bindkey '^y' autosuggest-accept

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

if command -v fastfetch &> /dev/null && [ -z "$SKIP_FASTFETCH" ]
then
    fastfetch
fi


#check if ~/.emacs.d/ exists and if so, add it to the pathdb
if [ -d "$HOME/.emacs.d" ]; then
    export PATH="$HOME/.emacs.d/bin:$PATH"
fi

if [ -d "$HOME/.config/emacs" ]; then
    export PATH="$HOME/.config/emacs/bin:$PATH"
fi

# check if _argocd file exists in the home directory and if so, source it 
if [ -f "$HOME/_argocd" ]; then
    source "$HOME/_argocd"
fi


# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/dkraklan/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions
