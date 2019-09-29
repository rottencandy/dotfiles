#!/bin/bash

icon="$HOME/.config/sxhkd/lock.png"
img="$HOME/.cache/i3lock.png"

scrot $img
# Pixelate image
convert $img -scale 10% -scale 1000% $img
# Blur image
#convert $img -blur 0x4 500% $img
convert $img $icon -gravity center -composite $img
i3lock -e -p default -i $img

sleep 2
xset dpms force off

