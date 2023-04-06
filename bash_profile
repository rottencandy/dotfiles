# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# vim: ft=sh ts=4 sw=4 sts=4 et fdm=marker fdl=0:

source /home/msaud/.config/broot/launcher/bash/br
