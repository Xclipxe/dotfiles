# Desktop Enviroment

This document introduce desktop enviroment.

It's components.

## Components

dwm + dmenu + st + slock + kanata?

picom + pywal + dunst + fcitx

## A Display Manager

use a SDDM to start a desktop enviroment
1. systemctl enable it
2. make a proper config file, /etc/sddm.conf, or a directory /etc/sddm.conf.d/

```
[Autologin]  # if add this tag, you will not halt in sddm and just login without password
User=xiepeixin
Session=dwm
```

this means there is a /usr/share/xsessions/dwm.desktop exist.

content:

```
[Desktop Entry]
Name=DWM
Comment=Dynamic Window Manager
Exec=dwm
Type=Application
DesktopNames=dwm
```

### Scaling

default scale is 1.0. It's too fucking small pixel for high resolution screen.

set it to 2.0 or something.
```shell
# .Xresources
# 96 * 2, setting dpi
Xft.dpi: 192

# apply it in .bash_profile, it will be sourced before dwm by sddm
xrdb -merge ~/.Xresources
```

### Scrolling

Default is not natually scrolling, which is so fucked up.

```shell
# check your touch pad property
xinput list
xinput list-props <your-touch-pad-id>
```

It could be observed that touch pad is using *libinput* driver (which I don't
know what it is). The point is, **Natually scrolling** is default disabled.

Create following file to set it right:

```shell
sudo vim /etc/X11/xorg.conf.d/30-touchpad.conf

# content
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "NaturalScrolling" "true"
EndSection
```

### Multi Monitor

Using `xrandr` to change the arrangement of monitors.

```shell
xrandr --output DP-3 --right-of eDP-1
```

### Timezone

Use `timedatectl` to change timezone.

### AppImage

install `appimagelauncher`, it's a helper.

### Keyboard Repeat Rate

```shell
# install xset
sudo pacman -S xorg-xset
# set rate
xset r rate 200 40
```

### Volume Control

```shell
sudo pacman -S pulsemixer
```

### Chinese Input

```shell
sudo pacman -S fcitx5-im fcitx5-chewing fcitx5-qt fcitx5-gtk fcitx5-chinese-addons
```

In ~/.local/bin/startdwm.sh: 

```shell
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx   # for games/SDL apps
```

### Screenshot

```shell
pacman -S scrot
# select a region and copy it to clipboard
scrot -s -f - | xclip -selection clipboard -t image/png
```

or **flameshot**.

### Notification

use notification daemon `dunst`

put `dunst &` in start script

in `~/.config/dunst/dunstrc`

```yaml
[global]
follow=mouse
```

when config file changed, use `dunstctl reload` to refresh setting

### Proxy

use cli tool `mihomo`

```shell
yay -S mihomo
```

copy config file from clash party, place it in `~/.config/mihomo/config.yaml`

then `sudo mihomo -d /home/xiepeixin/.config/mihomo`

### Sudo without passwd

edit `/etc/sudoers.d/99-nopasswd`

```text
xiepeixin ALL=(ALL) NOPASSWD: ALL
```

### Chrome browser

google-chrome-stable does not apply proxy by default(on arch) somehow.

you have to set it mannually.

```shell
google-chrome-stable --proxy-server="127.0.0.1:7890"
```

> reason found, see trouble shooting below

## Components Configuration

- dwm + st: basic settings
- nvim: dotfiles rg fzf bear

### dmenu

#### Patches

- center

- dwm-vanitygaps-6.2.diff

#### Scripts

- clipdmenu
    put `clipmenud &` in start script

### picom

picom is a compositor doing opacity round corner and stuff.

create config file in `~/.config/picom.conf`

run picom with

```shell
picom --backend glx
```

### feh - wallpaper

```shell
feh <image> --bg-max
```

add in start script

```shell
if [ -e ~/.fehbg ]; then
    ~/.fehbg
fi
```

### dwmblocks-async

- cpu temp

```shell
#!/bin/bash
correct_path="NULL"

for i in /sys/class/thermal/thermal_zone* ; do
    thermal_zone_type=$(cat "$i/type")
    if [ "$thermal_zone_type" == "x86_pkg_temp" ]; then
        correct_path=$i
    fi
done

if [ "$correct_path" != "NULL" ]; then
    temperature=$(($(cat "$correct_path/temp") / 1000))
    printf "%3.0f℃" $temperature
else
    printf "-1"
fi
```

- time

```shell
#!/bin/bash
date +%H:%M:%S
```

- battery

```shell
#!/bin/bash
capacity=$(cat /sys/class/power_supply/BAT0/capacity)
bat_status=$(cat /sys/class/power_supply/BAT0/status)


if [ "$bat_status" == "Charging" ]; then
    if [ $capacity -eq 100 ]; then
        battery="󰂅"
    elif [ $capacity -gt 80 ]; then
        battery="󰂊"
    elif [ $capacity -gt 60 ]; then
        battery="󰂉"
    elif [ $capacity -gt 40 ]; then
        battery="󰂈"
    else
        battery="󰂆"
    fi
else
    if [ $capacity -eq 100 ]; then
        battery="󰁹"
    elif [ $capacity -gt 80 ]; then
        battery="󰂁"
    elif [ $capacity -gt 60 ]; then
        battery="󰁿"
    elif [ $capacity -gt 40 ]; then
        battery="󰁽"
    else
        battery="󰁻"
    fi
fi

printf "%s%d" $battery $capacity
```

- cpu usage

```shell
#!/bin/bash

idle=$(iostat -c | awk '/avg-cpu/ { getline; print $6 }')
idle=$(printf "%.0f" $idle)
usage=$(( 100 - $idle ))

printf "%d%%" $usage
```

- memory usage

```shell
#!/bin/bash
available=$(free -h | awk '/Mem/ {print $7}' | awk -F 'G' '{print $1}')
total=$(free -h | awk '/Mem/ {print $2}' | awk -F 'G' '{print $1}')

percentage=$(( ($total - $available) * 100 / $total ))

printf "%d%%" $percentage
```

### slock

should have this in config.def.h

```c
static void set_window_class(Display *dpy, Window win) {
    XClassHint *class_hint = XAllocClassHint();
    if (!class_hint) {
        fprintf(stderr, "slock: unable to allocate class hint\n");
        return;
    }
    class_hint->res_name = "slock";
    class_hint->res_class = "slock";
    XSetClassHint(dpy, win, class_hint);
    XFree(class_hint);
}
```
## Troubole Shooting

### There are invalid symbol prepend elements in dwmblocks

Patch statuscmd to dwm

### Nvim clipboard

xclip

### Chinese Input

**DO NOT** select *keyboard - chinese* in fcitx5 configtool, it's just a
fucking layout. Select *pinyin*, fuck

### flameshot

[here](https://github.com/flameshot-org/flameshot/blob/master/docs/UsageX11MinimalWM.md)

use `flameshot config` to config that option then 

```shell
killall flameshot 2>/dev/null; flameshot &

flameshot gui
```

but, it still has a scale problem

### Chrome not using proxy

Because it doesn't get the enviroment variables.

it is started by a non-interactive bash, so .bashrc and .bash_profile
is not sourced.

### Sleeping

service should be opened to manage it via `systemsetting`

```shell
systemctl --user status plasma-powerdevil.service 
```

### OBS

OBS recording fail. go to settings, find record, advanced setting, switch encoder to ffmpeg

## TODO

### Proxy

periodically update config file from subscription url.

## Package

npm

sysstat

## Resources

https://www.nerdfonts.com/cheat-sheet
