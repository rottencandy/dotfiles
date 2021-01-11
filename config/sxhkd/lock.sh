#!/bin/bash

icon="$HOME/.config/sxhkd/lock.png"
img="$HOME/.cache/i3lock.png"

#maim -f jpg -m 1 $img

#convert $img -scale 10% -scale 1000% $img
#convert $img -blur 0x4 500% $img

#convert $img $icon -gravity center -composite $img

i3lock --ignore-empty-password --show-failed-attempts --tiling --pointer=default --image=$img

sleep 2
xset dpms force off

