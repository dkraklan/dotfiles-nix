# --- Powerlevel10k Instant Prompt ---
if [[ "$(uname)" == "Darwin" ]]; then
    typeset -g POWERLEVEL9K_INSTANT_PROMPT=off
fi

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# --- Oh My Zsh ---
export ZSH="$HOME/.oh-my-zsh"
DISABLE_AUTO_TITLE="true"
HIST_STAMPS="mm/dd/yyyy"

if [[ "$(uname)" != "Darwin" ]]; then
    # ---- Linux ----
    export ZSH_CUSTOM="${ZSH}/custom"

    # Symlink AUR-installed plugins into OMZ custom/plugins if not present
    for _plugin in zsh-syntax-highlighting zsh-autocomplete; do
        if [[ ! -e "$ZSH_CUSTOM/plugins/$_plugin" && -e "/usr/share/zsh/plugins/$_plugin" ]]; then
            ln -s "/usr/share/zsh/plugins/$_plugin" "$ZSH_CUSTOM/plugins/$_plugin"
        fi
    done
    unset _plugin

    plugins=(
        git
        poetry-env
        zsh-autocomplete
        docker
        rust
        kubectl
        zsh-syntax-highlighting  # keep LAST
    )

    export PATH="$HOME/.local/bin:$PATH"

    # Go
    if [[ -d "$HOME/go" ]]; then
        export GOPATH="$HOME/go"
        export PATH="$GOPATH/bin:$PATH"
    fi

    # Godot
    if [[ -d "$HOME/Desktop/Godot_Versions" ]]; then
        export PATH="$HOME/Desktop/Godot_Versions:$PATH"
    fi

    # Linuxbrew
    if [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    # Latest make
    if [[ -d "/opt/make-4.4/bin" ]]; then
        export PATH="/opt/make-4.4/bin:$PATH"
    fi

    # Starship
    if command -v starship &>/dev/null; then
        eval "$(starship init zsh)"
    fi

    # Direnv
    if command -v direnv &>/dev/null; then
        eval "$(direnv hook zsh)"
    fi

else
    # ---- macOS ----

    # Homebrew (must be first)
    if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi

    # Cache brew prefix to avoid repeated subshells
    _brew_prefix="${HOMEBREW_PREFIX:-/opt/homebrew}"

    # Plugins (source directly — no brew subshells)
    [[ -r "$_brew_prefix/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh" ]] \
        && source "$_brew_prefix/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh"

    [[ -r "$_brew_prefix/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] \
        && source "$_brew_prefix/opt/zsh-autosuggestions/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

    [[ -r "$_brew_prefix/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] \
        && source "$_brew_prefix/opt/zsh-syntax-highlighting/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

    # Zoxide
    if command -v zoxide &>/dev/null; then
        eval "$(zoxide init zsh)"
    fi

    ZSH_THEME="powerlevel10k/powerlevel10k"

    # SSH keys (interactive shells only)
    if [[ -o interactive ]]; then
        ssh-add ~/.ssh/dylan_id_ed25519 2>/dev/null
        ssh-add ~/.ssh/id_github_ed25519 2>/dev/null
    fi

    plugins=(git docker)

    # Aliases
    alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
    alias pathssh="~/.scripts/path_ssh_proxy.sh"
    alias dirgrep="~/.scripts/dirgrep.sh"
    alias pathdb="~/.scripts/db_proxy.sh"
    alias catclip="~/.scripts/catclip.sh"
    alias sslexpire="~/.scripts/sslexpire.sh"
    alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
    alias tl="$HOME/.config/scripts/tmux_launch.sh"
    alias python=python3
    alias gam="$HOME/bin/gam/gam"

    # Extra PATH (direct checks, no brew subshells)
    [[ -d "$_brew_prefix/opt/libpq/bin" ]] && export PATH="$_brew_prefix/opt/libpq/bin:$PATH"
    [[ -d "$_brew_prefix/opt/mysql-client/bin" ]] && export PATH="$_brew_prefix/opt/mysql-client/bin:$PATH"

    # Starship
    if command -v starship &>/dev/null; then
        eval "$(starship init zsh)"
    fi

    unset _brew_prefix
fi

# --- Shared ---
alias dockps="sudo docker ps --format 'table {{.Names}}\t{{.Status}}'"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'

# SSH wrapper: rename tmux window to hostname during connection
ssh() {
    if [[ -n "$TMUX" ]]; then
        local hostname=""
        local -a ssh_args=("$@")

        local i=1
        while [[ $i -le ${#ssh_args[@]} ]]; do
            case "${ssh_args[$i]}" in
                -[1246AaCfGgKkMNnqsTtVvXxYy])
                    ;;
                -[bcDEeFIiJLlmOopQRSWw])
                    ((i++))
                    ;;
                -*)
                    # Option with = format — just skip it
                    ;;
                *)
                    hostname="${ssh_args[$i]}"
                    break
                    ;;
            esac
            ((i++))
        done

        hostname="${hostname##*@}"
        hostname="${hostname%%:*}"

        if [[ -n "$hostname" ]]; then
            local original_name=$(tmux display-message -p '#W')
            tmux rename-window "$hostname"
            command ssh "$@"
            tmux rename-window "$original_name"
        else
            command ssh "$@"
        fi
    else
        command ssh "$@"
    fi
}

source "$ZSH/oh-my-zsh.sh"

# --- History ---
HISTFILE="$HOME/.zsh_history"
HISTSIZE=500000
SAVEHIST=500000
setopt appendhistory
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# --- Keybindings ---
bindkey '^y' autosuggest-accept

# --- Prompt ---
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# --- Optional tools ---
if command -v fastfetch &>/dev/null && [[ -z "$SKIP_FASTFETCH" ]]; then
    fastfetch
fi

# Emacs
[[ -d "$HOME/.emacs.d" ]] && export PATH="$HOME/.emacs.d/bin:$PATH"
[[ -d "$HOME/.config/emacs" ]] && export PATH="$HOME/.config/emacs/bin:$PATH"

# Local overrides
[[ -f "$HOME/_argocd" ]] && source "$HOME/_argocd"
[[ -f "$HOME/.zshlocal" ]] && source "$HOME/.zshlocal"
