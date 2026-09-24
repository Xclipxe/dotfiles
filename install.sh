#!/bin/bash
# 1. test network, if github ok
# 2. clone dwm, slock, st, dmenu, dwmblocks-async from github:Xclipxe
# 3. install dependent packages
# 4. set up those .config files
# 5. build dwm, slock...

sudo echo "got a sudo priviledge"

timeout 5 wget -q --spider github.com
case $? in
    0) echo "network fine start install packages..." ;;
    *) echo "get a fucking fine network!" ; exit 1 ;;
esac

COMPONENTS_PATH="$HOME/documents/desktop_enviroment_repo"
GITHUB_PREFIX="https://github.com/Xclipxe"
DWM_URL="$GITHUB_PREFIX/dwm.git"
ST_URL="$GITHUB_PREFIX/st.git"
SLOCK_URL="$GITHUB_PREFIX/slock.git"
DWMBLOCKS_ASYNC_URL="$GITHUB_PREFIX/dwmblocks-async.git"
DMENU_URL="$GITHUB_PREFIX/dmenu.git"

mkdir -p $COMPONENTS_PATH

git clone $DWM_URL $COMPONENTS_PATH/dwm
git clone $ST_URL $COMPONENTS_PATH/st
git clone $SLOCK_URL $COMPONENTS_PATH/slock
git clone $DWMBLOCKS_ASYNC_URL $COMPONENTS_PATH/dwmblocks-async
git clone $DMENU_URL $COMPONENTS_PATH/dmenu

echo "=====================get repos"

sudo pacman -S picom dunst fcitx5-im fcitx5-chewing fcitx5-qt fcitx5-gtk \
    fcitx5-chinese-addons xorg-xset pulsemixer scrot npm sysstat \
    feh xclip flameshot clipmenu base-devel libxft \
    xorg-xrdb xorg-xrandr xorg-xinput sddm

yay -S mihomo google-chrome

echo "=====================packages installed"

if [ -e "$HOME/.config/dunst" ]; then
    echo "dunst config file already exist"
else
    mkdir -p "$HOME/.config/dunst"
    cp ".config/dunst/dunstrc" "$HOME/.config/dunst/dunstrc"
fi

if [ -e "$HOME/.config/flameshot" ]; then
    echo "flameshot config file already exist"
else
    mkdir -p "$HOME/.config/flameshot"
    cp ".config/flameshot/flameshot.ini" "$HOME/.config/flameshot/flameshot.ini"
fi

if [ -f "$HOME/.config/picom.conf" ]; then
    echo "picon config file already exist"
else
    cp ".config/picom.conf" "$HOME/.config/picom.conf"
fi

if [ -f "$HOME/.Xresources" ]; then
    echo ".Xresource already exist"
else
    cp .Xresources $HOME
fi

cp .local/bin/startdwm.sh "$HOME/.local/bin/"

if [ -f /usr/share/X11/xorg.conf.d/40-libinput.conf ]; then
    echo "/usr/share/X11/xorg.conf.d/40-libinput.conf exist"
else
    sudo tee /usr/share/X11/xorg.conf.d/40-libinput.conf << 'EOF'
Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
    Option "NaturalScrolling" "true"
EndSection
EOF
fi

echo "=====================config files ready"

sudo make -C $COMPONENTS_PATH/dwm clean install
sudo make -C $COMPONENTS_PATH/st clean install
sudo make -C $COMPONENTS_PATH/slock clean install
sudo make -C $COMPONENTS_PATH/dwmblocks-async clean install
sudo make -C $COMPONENTS_PATH/dmenu clean install

echo "=====================components installed"

sudo mkdir -p /etc/sddm.conf.d
sudo tee /etc/sddm.conf.d/DWM << 'EOF'
User=xiepeixin
Session=dwm
EOF

sudo tee /usr/share/xsessions/dwm.desktop << 'EOF'
[Desktop Entry]
Name=DWM
Comment=Dynamic Window Manager
Exec=/home/xiepeixin/.local/bin/startdwm.sh
Type=Application
DesktopNames=dwm
EOF

tee $HOME/bin/cpu_temp.sh << 'EOF'
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
EOF
chmod +x $HOME/bin/cpu_temp.sh

tee $HOME/bin/print_time.sh << 'EOF'
#!/bin/bash
date +%H:%M:%S
EOF
chmod +x $HOME/bin/print_time.sh

tee $HOME/bin/battery_info.sh << 'EOF'
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
EOF
chmod +x $HOME/bin/battery_info.sh

tee $HOME/bin/cpu_usage.sh << 'EOF'
#!/bin/bash

idle=$(iostat -c | awk '/avg-cpu/ { getline; print $6 }')
idle=$(printf "%.0f" $idle)
usage=$(( 100 - $idle ))

printf "%d%%" $usage
EOF
chmod +x $HOME/bin/cpu_usage.sh


sudo systemctl disable plasmalogin
sudo systemctl enable sddm

echo "all set up, try reboot!"
