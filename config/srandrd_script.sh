#!/usr/bin/bash

case "${SRANDRD_OUTPUT} ${SRANDRD_EVENT}" in
	"HDMI2 connected") xrandr --output HDMI2 --auto --left-of eDP1;;
	"HDMI2 disconnected") xrandr --output HDMI2 --off --output VIRTUAL1 --off;;
esac
