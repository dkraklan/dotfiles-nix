if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


export ZSH="$HOME/.oh-my-zsh"

if [[ "$(uname)" != "Darwin" ]]; then
	#ZSH_THEME="powerlevel10k/powerlevel10k"
else
    ZSH_THEME="powerlevel10k/powerlevel10k"
fi

typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

 DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

HIST_STAMPS="mm/dd/yyyy"


 # For now we run seperate plugins on mac / linx so we differenate here
if [[ "$(uname)" == "Darwin" ]]; then
    plugins=(git poetry-env zsh-autosuggestions)
else
    plugins=(
        git
        poetry-env
        zsh-autosuggestions
        zsh-syntax-highlighting
        docker
    )
fi


source $ZSH/oh-my-zsh.sh

HISTFILE="$HOME/.zsh_history"
HISTSIZE=500000
SAVEHIST=500000
setopt appendhistory
setopt INC_APPEND_HISTORY  
setopt SHARE_HISTORY

#Keybindings
bindkey '^ ' autosuggest-accept

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
export PATH="$HOME/.poetry/bin:$PATH"

if command -v fastfetch &> /dev/null 
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
	
	export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
	export PATH=/opt/homebrew/bin:$PATH
	
	function gam() { "/Users/dkraklan/bin/gam/gam" "$@" ; }
  
	eval "$(starship init zsh)"

	#source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
else
    #source ~/.oh-my-zsh/custom/themes/powerlevel10k/powerlevel10k.zsh-theme
    eval "$(starship init zsh)"
fi

