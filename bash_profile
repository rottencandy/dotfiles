# sources {{{
#---------------------------------------------------------------------
# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# }}}

# Shell vars {{{
#---------------------------------------------------------------------
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

export SYSTEMD_PAGER=

export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
export XMODIFIERS="@im=fcitx"

# }}}

# Aliases {{{
#---------------------------------------------------------------------

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias \
        ls='ls -hN --color=auto --group-directories-first' \
        dir='dir --color=auto' \
        vdir='vdir --color=auto' \

        grep='grep --color=auto' \
        fgrep='fgrep --color=auto' \
        egrep='egrep --color=auto'
fi

alias \
    acp='cpg -g' \
    amv='mvg -g' \
    gd='DELTA_NAVIGATE=1 git diff' \
    gr='cd ./$(git rev-parse --show-cdup)' \
    k='kubectl' \
    l='ls -CF' \
    la='lsd -A' \
    ll='lsd -l' \
    nb='cd ~/nb && nvim -c "exec \"normal 1 f\""' \
    nv='nvim' \
    nvdaemon='nvim --headless --listen localhost:6666' \
    scrt='maim -g $(slop -q) scrt-screenshot-$(date +%s).png 2> /dev/null' \
    t='tmux' \
    tree='lsd --tree' \
    ungr='gron --ungron' \
    v='vim -X' \
    yt='yt-dlp --add-metadata -i' \
    ytb='yt-dlp --add-metadata -i -f bestvideo+bestaudio' \
    yta='yt --add-metadata -x -f bestaudio'

_completion_loader sudo tmux
complete -F _sudo s
complete -F _tmux t

# }}}

# vim: ft=sh ts=4 sw=4 sts=4 et fdm=marker fdl=0:
