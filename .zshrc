# ~/.zshrc — fish-like experience, no oh-my-zsh

# ----- History -----
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY       # write history as commands run
setopt SHARE_HISTORY            # share across open shells
setopt HIST_IGNORE_ALL_DUPS     # skip duplicate entries

# ----- Completion -----
# Note: zsh-completions is auto-loaded from /usr/share/zsh/site-functions (already in $fpath)
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select                        # arrow-key selection (fallback)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'    # case-insensitive
setopt COMPLETE_IN_WORD

# ----- Line editing (fish-like) -----
# Ctrl+W kills only the last path component (stop at '/'), like fish's backward-kill-path-component
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# ----- Autosuggestion (gray ghost text) -----
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# accept a suggestion: -> or End (whole line), Ctrl+F (one word)

# ----- fzf-tab (fuzzy selection menu) -----
source /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh
zstyle ':fzf-tab:*' fzf-flags --height=40% --layout=reverse

# ----- Syntax highlighting (fish colors) — MUST be last -----
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias rm='trash-put'
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
eval "$(zoxide init zsh)"

# ============================================================
# ============================================================
# ============================================================
# ----- Prompt (converted from fish_prompt.fish — Gruvbox Dark) -----
# ============================================================
setopt PROMPT_SUBST

autoload -Uz add-zsh-hook
zmodload -i zsh/datetime     # provides $EPOCHREALTIME / $EPOCHSECONDS (used for command duration)
zmodload -i zsh/mathfunc

__git_branch=""
__prompt_dir=""
typeset -F __cmd_start=0.0

# Git branch name only (no dirty status -> fast)
function _fish_prompt_git_branch {
    local branch
    branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
    if [[ -n "$branch" ]]; then
        __git_branch="  ${branch} "   # git icon + branch, with padding
    else
        __git_branch=" "                    # single space keeps a thin blue block
    fi
}

# Directory: $HOME -> ~ (full path kept) + leading folder icon
function _fish_prompt_dir {
    local dir="${PWD/#$HOME/~}"
    case "$dir" in
        '~')               dir="  $dir" ;;   # home
        '~/Documents'*)    dir=" 󰈙 $dir" ;;
        '~/Downloads'*)    dir="  $dir" ;;
        '~/Music'*)        dir=" 󰝚 $dir" ;;
        '~/Pictures'*)     dir="  $dir" ;;
        '~/Developer'*)    dir=" 󰲋 $dir" ;;
    esac
    __prompt_dir="$dir"
}

function _fish_prompt_preexec {
    __cmd_start=$EPOCHREALTIME
}
add-zsh-hook preexec _fish_prompt_preexec

function _fish_prompt_duration {
    local -i ms
    local duration=""
    RPROMPT=""
    (( __cmd_start > 0 )) || return
    ms=$(( int((EPOCHREALTIME - __cmd_start) * 1000 + 0.5) ))
    __cmd_start=0.0
    (( ms > 100 )) || return   # hide unless > 100ms

    if (( ms >= 3600000 )); then
        duration="[$(( ms / 3600000 ))]h [$(( (ms % 3600000) / 60000 ))]m"
    elif (( ms >= 60000 )); then
        duration="[$(( ms / 60000 ))]m [$(( (ms % 60000) / 1000 ))]s"
    elif (( ms >= 1000 )); then
        duration="[$(printf '%.2f' $(( ms / 1000.0 )))]s"
    else
        duration="[$ms]ms"
    fi

    RPROMPT="%F{#928374}󰔛 $duration %f"
}

function _fish_prompt_precmd {
    _fish_prompt_git_branch
    _fish_prompt_dir
    _fish_prompt_duration
}
add-zsh-hook precmd _fish_prompt_precmd

# Left prompt, line 1: powerline-style segments (Gruvbox Dark)
PROMPT='%F{#d79921}%K{#d79921}%F{#fbf1c7}󰀵 %n %K{#689d6a}%F{#d79921}%F{#fbf1c7} ${__prompt_dir} %K{#458588}%F{#689d6a}%F{#fbf1c7}${__git_branch}%K{#3c3836}%F{#458588}%F{#fbf1c7}  %D{%H:%M} %k%F{#3c3836}
%(?.%F{#98971a}.%F{#cc241d})%B %b%f'

alias ls='ls --color=auto'
alias ll='ls --color=auto -lh'

cat ~/Pictures/gnu-head-terminal.txt
