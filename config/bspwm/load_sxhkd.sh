#! /usr/bin/bash

if [ -z $(pgrep -u $UID -x sxhkd) ]; then
    sxhkd &
else
    pkill -USR1 -x sxhkd
fi
