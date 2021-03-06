#!/usr/bin/bash

# Run program only if it is not already running
runonce() {
	if ! pgrep $1 > /dev/null ; then
		$@ &
	fi
}

xrdb ~/.Xresources

xmodmap ~/.Xmodmap

# https://askubuntu.com/questions/931761/how-to-fix-palm-rejection-on-ubuntu-16-04-lts
xinput --set-prop "SynPS/2 Synaptics TouchPad"  "libinput Accel Speed" 0.6
xinput --set-prop "SynPS/2 Synaptics TouchPad"  "libinput Natural Scrolling Enabled" 1
#xinput --set-prop "SynPS/2 Synaptics TouchPad"  "libinput Disable While Typing Enabled" 1

runonce fcitx -d

runonce kdeconnect-indicator

if ! pgrep xidlehook > /dev/null ; then
	xidlehook \
		--not-when-fullscreen \
		--not-when-audio \
		--detect-sleep \
		--timer 60 \
		'lockscreen' \
		'' \
		--timer 5 \
		'xset dpms force off' \
		'' \
		--timer 3600 \
		'systemctl suspend' \
		'' \
		--socket /tmp/xidlehook.sock &
fi

#runonce picom --ex
