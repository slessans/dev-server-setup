export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="sl-agnoster"

zstyle ':omz:update' mode disabled  # disable automatic updates
COMPLETION_WAITING_DOTS="true"  # display red dots whilst waiting for completion.

plugins=(
    git
    web-search
    jsontools
)

source $ZSH/oh-my-zsh.sh

# User configuration

export DEFAULT_USER=s

# fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# zoxide
eval "$(zoxide init zsh)"

