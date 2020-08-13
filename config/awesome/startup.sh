#!/usr/bin/env bash

# Run program only if it is not already running
function run {
    if ! pgrep $1 > /dev/null ;
    then
        $@&
    fi
}

xrdb ~/.Xresources

xmodmap ~/.Xmodmap

xinput --set-prop "SynPS/2 Synaptics TouchPad" "libinput Accel Speed" 0.6
#xinput --set-prop "SynPS/2 Synaptics TouchPad" "libinput Disable While Typing Enabled" 1

run fcitx -d

run kdeconnect-indicator

#run picom --ex
