#!/usr/bin/bash

# Run program only if it is not already running
runonce() {
	if ! pgrep $1 > /dev/null ; then
		$@ &
	fi
}

runonce fcitx -d
runonce kdeconnect-indicator
feh --bg-scale ~/Pictures/wall.jpg

# X11 specific
xrdb ~/.Xresources

# https://askubuntu.com/questions/931761/how-to-fix-palm-rejection-on-ubuntu-16-04-lts
# use xinput list
xinput --set-prop "SynPS/2 Synaptics TouchPad"  "libinput Accel Speed" 0.6
xinput --set-prop "SynPS/2 Synaptics TouchPad"  "libinput Natural Scrolling Enabled" 1
xinput --set-prop "SynPS/2 Synaptics TouchPad"  "libinput Disable While Typing Enabled" 1
# Run separately because runonce has problems with multiline commands
if ! pgrep xidlehook > /dev/null ; then
	~/.cargo/bin/xidlehook \
		--not-when-fullscreen \
		--not-when-audio \
		--detect-sleep \
		--socket /tmp/xidlehook.sock \
		--timer 60 \
		'lockscreen' \
		'' \
		--timer 5 \
		'xset dpms force off' \
		'' \
		--timer 3600 \
		'systemctl suspend' \
		'' &
fi
# Replaced by keyd
#xmodmap ~/.Xmodmap
#runonce picom --ex
runonce srandrd -e ~/.config/srandrd_script.sh
