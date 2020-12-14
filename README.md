Managed with [bashdot](https://github.com/bashdot/bashdot).

Dotfiles
========

Dotfiles.

Install
-------

Warning: Make sure to create a backup of your existing files, `bashdot` creates symlinks of all config files and might delete existing files.

```bash
git clone --recursive https://github.com/rottencandy/dotfiles
bashdot install dotfiles
```

Dependencies
----------

### Necessary

- st
- i3lock
- awesome
- acpi
- xbacklight
- amixer
- pactl
- git-delta
- starship

### Good to have

- fzf
- rg
- fd
- tmux
- nnn
- broot
- lsd
- fbterm
- slop, maim
- mpd, ncmpcpp
- Fcitx
- KDE Connect

AwesomeWM
---------
Use `startup.sh` as init script. Has synaptics touchpad settings.
