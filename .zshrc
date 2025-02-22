export PATH
export CLICOLOR='Yes'
# export LSCOLORS='ExGxFxdaCxDaDahbadacec'

# PROMPT='%1~ %F{#FF5F57}>%F{#FFBC2E}>%F{#27C841}>%F{#0079FA}>%f '
PROMPT='%1~ %F{#FF5F57}>%F{#FFBC2E}>%F{#27C841}>%f '
alias ll='ls -l'
home='/Volumes/xpx'
xpx='/Volumes/xpx/documents/school/仓库/xpxstation'
alias cdhome="cd $home"
alias cdxpx="cd $xpx"
LANG=zh_HK.utf-8
___MY_VMOPTIONS_SHELL_FILE="${HOME}/.jetbrains.vmoptions.sh"; if [ -f "${___MY_VMOPTIONS_SHELL_FILE}" ]; then . "${___MY_VMOPTIONS_SHELL_FILE}"; fi


export STM32CubeMX_PATH=/Applications/STMicroelectronics/STM32CubeMX.app/Contents/Resourcesexport 
# HOMEBREW_BOTTLE_DOMAIN=https://mirrors.aliyun.com/homebrew/homebrew-bottles
PATH=$PATH:/usr/local/opt/ricv-gnu-toolchain/bin:/System/Volumes/Data/opt/homebrew/opt/riscv-gnu-toolchain/bin:/System/Volumes/Data/opt/homebrew/opt/qemu/bin

function proxy_on() {
    export http_proxy=http://127.0.0.1:7890
    export https_proxy=http://127.0.0.1:7890
    echo -e "终端代理已开启"
}

function proxy_off() {
    unset http_proxy https_proxy
    echo -e "终端代理已关闭"
}

alias ctags="$(brew --prefix)/bin/ctags"

# 以下是关于os学习用的
alias gdb="riscv64-elf-gdb"
mit="$home/documents/project/mit/MIT6.S081-2020-labs"
alias cdmit="cd $mit"

# fzf 
source <(fzf --zsh)

# yazi, allow change directory when quit
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# add homebrew include path
export C_INCLUDE_PATH="/opt/homebrew/include:$C_INCLUDE_PATH"
export LIBRARY_PATH="/opt/homebrew/lib:$LIBRARY_PATH"

# let homebrew's software be the first
export PATH="/opt/homebrew/bin:$PATH"
