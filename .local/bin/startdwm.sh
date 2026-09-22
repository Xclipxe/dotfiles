#!/bin/bash

xrdb -merge ~/.Xresources

dwmblocks &

xset r rate 200 40

# Fcitx5 environment variables
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx   # for games/SDL apps

export http_proxy=http://127.0.0.1:7890
export https_proxy=http://127.0.0.1:7890

fcitx5 -d
flameshot &
clipmenud &
dunst &

xrandr --output DP-3 --left-of eDP-1

sudo mihomo -d /home/xiepeixin/.config/mihomo &

picom --backend glx &

if [ -e /home/xiepeixin/.fehbg ]; then
    ~/.fehbg
fi

export XCURSOR_SIZE=96

exec dwm
