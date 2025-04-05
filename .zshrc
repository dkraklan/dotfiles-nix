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
    # Linux config
    source .oh-my-zsh/custom/plugins/zsh-autocomplete/zsh-autocomplete.plugin.zsh

else
    #Macos config
    source $(brew --prefix)/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    source $(brew --prefix zsh-autosuggestions)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    eval "$(zoxide init zsh)"
    ZSH_THEME="powerlevel10k/powerlevel10k"
fi


DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

HIST_STAMPS="mm/dd/yyyy"


 # For now we run seperate plugins on mac / linx so we differenate here
if [[ "$(uname)" == "Darwin" ]]; then
    plugins=(
        git
        docker
        # poetry-env
        # zsh-autosuggestions
    )
else
    plugins=(
        git
        poetry-env
        zsh-autosuggestions
        zsh-syntax-highlighting
        docker
    	rust
        kubectl
    )
fi


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

#machine / os specific sections
if [[ "$(uname)" == "Darwin" ]]; then
	alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
	alias pathssh="~/.scripts/path_ssh_proxy.sh"
	alias dirgrep="~/.scripts/dirgrep.sh"
	alias pathdb="~/.scripts/db_proxy.sh"
	alias catclip="~/.scripts/catclip.sh"
	alias sslexpire="~/.scripts/sslexpire.sh"
	alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
    alias tl="/Users/dkraklan/.config/scripts/tmux_launch.sh"
	export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
	export PATH=/opt/homebrew/bin:$PATH
	alias python=python3

	function gam() { "/Users/dkraklan/bin/gam/gam" "$@" ; }
  
	eval "$(starship init zsh)"

	#source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
else
    #source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
    eval "$(starship init zsh)"
    export GOPATH=~/go
    export PATH=$GOPATH/bin:$PATH
    #docker command to show all containers but just the names and status
    alias dockps="sudo docker ps --format 'table {{.Names}}\t{{.Status}}'"
fi


#check if ~/.emacs.d/ exists and if so, add it to the pathdb
if [ -d "$HOME/.emacs.d" ]; then
    export PATH="$HOME/.emacs.d/bin:$PATH"
fi


eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
