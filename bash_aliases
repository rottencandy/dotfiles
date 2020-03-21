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
    ll='ls -l' \
    la='ls -A' \
    l='ls -CF' \
    t='tmux' \
    v='vim' \
    g='git' \
    fd='fdfind' \
    k='kubectl' \
    yt="youtube-dl --add-metadata -i" \
    yta="yt --add-metadata -x -f bestaudio" \
    nc="ncmpcpp"

# vim: ts=4 sw=4 sts=4 et fdm=marker:
