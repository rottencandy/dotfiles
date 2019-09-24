#! /usr/bin/bash

bspc subscribe monitor | while read -r line; do
  case $line in
      monitor_add*|monitor_geometry*)
        if [ "$(bspc query -M | wc -l)" -eq "2" ]; then
          bspc monitor $(bspc query -M | sed -n 1p) -d 00 02 04
          bspc monitor $(bspc query -M | sed -n 2p) -d 01 03 05
        elif [ "$(bspc query -M | wc -l)" -eq "3" ]; then
          bspc monitor $(bspc query -M | sed -n 1p) -d 00 03
          bspc monitor $(bspc query -M | sed -n 2p) -d 01 04
          bspc monitor $(bspc query -M | sed -n 3p) -d 02 05
        else
          bspc monitor -d I II III IV V VI VII VIII IX X
        fi
        ;;
      *)
      ;;
  esac
done &
