#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\u@\h \W]\$ '
alias rm='trash-put'

export XMODIFIERS=@im=fcitx
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# glm
# export ANTHROPIC_AUTH_TOKEN="sk-ETD39iulQ6t6K03V5OFu1mRRBpRcyT1WAipubv5sBOnCJF0J"

# ds
export PATH="/home/xiepeixin/bin:$PATH"
export PATH="/home/xiepeixin/.local/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

zsh