#!/bin/bash

# setup
if [ $(pgrep -cx panel) -gt 1 ] ; then
    printf "%s\n" "The panel is already running." >&2
    exit 1
fi

#circle: \uf10c \uf111
#star: \uf005
#square: \uf0c8
bspwm() {
    BSPWM=$(bspc query -D)
    BUSY=$(bspc query -D -d .occupied)

    for DESK in $BSPWM
    do
        INDICATOR="\uf10c"
        if [[ $BUSY =~ $DESK ]]; then
            INDICATOR="\uf111"
        fi
        #echo -n "%{A:bspc desktop $DESK -f:}"
        if [ $DESK = $(bspc query -D -d) ]; then
            echo -n "%{F#009eff}$INDICATOR%{F-}"
        else
            echo -n "$INDICATOR"
        fi
        #echo -n "%{A} "
        echo -n " "
    done
}

clock() {
    clk=$(date "+%l:%M %p")
    echo -n $clk
}

temp() {
    temp=$(sensors | grep "id 0" | cut -d'+' -f2 | head -c7)
    echo -n $temp
}

cal() {
    cal=$(date "+%A, %e %b")
    echo -n $cal
}

#\uf6a9 mute
volume() {
    vol=$(amixer get Master | tail -n 1 | cut -d"[" -f2 | head -c3)
    echo -n $vol
}

while true; do
    echo -e "%{l}$(bspwm)%{c}$(clock)%{r}\uf028 $(volume)    \uf2c9 $(temp)   \uf133 $(cal) "
    sleep .5
done

