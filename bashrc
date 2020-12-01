# bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

#if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#    tmux
#fi


# sources {{{
#---------------------------------------------------------------------

# If stuff here is commented it's because it's slow

test -s /etc/bashrc          && . /etc/bashrc

# FZF options
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

#if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
#    . /usr/share/doc/fzf/examples/key-bindings.bash
#fi

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# }}}

# Prompt {{{
#---------------------------------------------------------------------
# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
# (found this in Debian's bashrc)

# prompt
BGREEN='\[\033[1;32m\]'
GREEN='\[\033[0;32m\]'
BRED='\[\033[1;31m\]'
RED='\[\033[0;31m\]'
BBLUE='\[\033[1;34m\]'
BLUE='\[\033[0;34m\]'
CYAN='\[\033[0;36m\]'
NORMAL='\[\033[00m\]'

PS1="${BLUE}(${GREEN}\w${BLUE}) ${RED}\$ ${NORMAL}"

# }}}

# Shell options {{{
#---------------------------------------------------------------------

stty -ixon # Disable <C-s> & <C-q>
shopt -s autocd # cd on dir name
#shopt -s cdspell
shopt -s checkwinsize #update LINES and COLUMNS on window resize
shopt -s cmdhist # combine multiline commands into one
shopt -s histappend
shopt -s globstar
shopt -s extglob
shopt -s nullglob
unset command_not_found_handle

# better less for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

#}}}

# Custom functions {{{
#---------------------------------------------------------------------

# nnn with cd on quit
n ()
{
    # Block nesting of nnn in subshells
    if [ -n $NNNLVL ] && [ "${NNNLVL:-0}" -ge 1 ]; then
        echo "nnn is already running"
        return
    fi

    # To cd on quit only on ^G, remove the "export"
    # NOTE: NNN_TMPFILE is fixed, should not be modified
    export NNN_TMPFILE="${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd"

    # Unmask ^Q (, ^V etc.) (if required, see `stty -a`) to Quit nnn
    # stty start undef
    # stty stop undef
    # stty lwrap undef
    # stty lnext undef

    nnn "$@"

    if [ -f "$NNN_TMPFILE" ]; then
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

# do sudo, or sudo the last command if no argument given
s() {
    if [[ $# == 0 ]]; then
        echo sudo $(history -p '!!')
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}

# open file using fzf with max recursive depth
# fld [depth] [cmd]
fld() {
    fzfcmd="fd -Hd 1"
    cmd=nvim
    if [ $# -eq 1 ]
    then
        cmd=$1
    elif [ $# -eq 2 ]
    then
        fzfcmd="fd -Hd $1"
        cmd=$2
    fi
    file=$($fzfcmd | fzf) || return
    $cmd "$file"
}

# ftpane - switch pane (@george-b)
# bind f run "tmux split-window -v -l 10 'bash -ci ftpane'"
ftpane() {
    local panes current_window current_pane target target_window target_pane
    panes=$(tmux list-panes -s -F '#I:#P - #{pane_current_path} #{pane_current_command}')
    current_pane=$(tmux display-message -p '#I:#P')
    current_window=$(tmux display-message -p '#I')

    target=$(echo "$panes" | grep -v "$current_pane" | fzf +m --reverse) || return

    target_window=$(echo $target | awk 'BEGIN{FS=":|-"} {print$1}')
    target_pane=$(echo $target | awk 'BEGIN{FS=":|-"} {print$2}' | cut -c 1)

    if [[ $current_window -eq $target_window ]]; then
        tmux select-pane -t ${target_window}.${target_pane}
    else
        tmux select-pane -t ${target_window}.${target_pane} &&
            tmux select-window -t $target_window
    fi
}

# Graphical git log
glog() {
    setterm -linewrap off

    git --no-pager log --all --color=always --graph --abbrev-commit --decorate \
        --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' | \
        sed -E \
        -e 's/\|(\x1b\[[0-9;]*m)+\\(\x1b\[[0-9;]*m)+ /├\1─╮\2/' \
        -e 's/(\x1b\[[0-9;]+m)\|\x1b\[m\1\/\x1b\[m /\1├─╯\x1b\[m/' \
        -e 's/\|(\x1b\[[0-9;]*m)+\\(\x1b\[[0-9;]*m)+/├\1╮\2/' \
        -e 's/(\x1b\[[0-9;]+m)\|\x1b\[m\1\/\x1b\[m/\1├╯\x1b\[m/' \
        -e 's/╮(\x1b\[[0-9;]*m)+\\/╮\1╰╮/' \
        -e 's/╯(\x1b\[[0-9;]*m)+\//╯\1╭╯/' \
        -e 's/(\||\\)\x1b\[m   (\x1b\[[0-9;]*m)/╰╮\2/' \
        -e 's/(\x1b\[[0-9;]*m)\\/\1╮/g' \
        -e 's/(\x1b\[[0-9;]*m)\//\1╯/g' \
        -e 's/^\*|(\x1b\[m )\*/\1⎬/g' \
        -e 's/(\x1b\[[0-9;]*m)\|/\1│/g' \
        | command less -r +'/[^/]HEAD'

    setterm -linewrap on
}

# Open file selection in vim
# bind 2 run "tmux split-window -h -b -l 45 'bash -ci nnnfiles'"
nnnfiles () {
    search_dir=$1 || "~"
    selection=$(nnn -p - $search_dir)
    if [$selection -eq ""]; then
        return
    fi
    nvim $selection
}

# This script was automatically generated by the broot program
# More information can be found in https://github.com/Canop/broot
# This function starts broot and executes the command
# it produces, if any.
# It's needed because some shell commands, like `cd`,
# have no useful effect if executed in a subshell.
function br {
    f=$(mktemp)
    (
    set +e
    broot --outcmd "$f" "$@"
    code=$?
    if [ "$code" != 0 ]; then
        rm -f "$f"
        exit "$code"
    fi
)
code=$?
if [ "$code" != 0 ]; then
    return "$code"
fi
d=$(<"$f")
rm -f "$f"
eval "$d"
}

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
    ll='lsd -l' \
    la='lsd -A' \
    l='ls -CF' \
    tree='lsd --tree' \
    t='tmux' \
    v='vim' \
    nv='nvim' \
    nb='cd ~/nb && nvim -c "exec \"normal 1 f\""' \
    gs='git status' \
    gd='git diff' \
    gr='cd ./$(git rev-parse --show-cdup)' \
    k='kubectl' \
    yt='youtube-dl --add-metadata -i' \
    yta='yt --add-metadata -x -f bestaudio' \
    nc="ncmpcpp" \
    scrt='maim -g $(slop -q) scrt-screenshot-$(date +%s).png'

# }}}

# Path exports {{{
#---------------------------------------------------------------------

test -s $HOME/.local/bin          && PATH="$PATH:$HOME/.local/bin"
test -s $HOME/bin                 && PATH="$PATH:$HOME/bin"
test -s $HOME/go/bin              && PATH="$PATH:$HOME/go/bin"
test -s $HOME/code/go/bin         && PATH="$PATH:$HOME/code/go/bin"
test -s $HOME/.cargo/bin          && PATH="$PATH:$HOME/.cargo/bin"
test -s $HOME/.gem/ruby/2.5.0/bin && PATH="$PATH:$HOME/.gem/ruby/2.5.0/bin"
test -s $HOME/.node_caches/bin    && PATH="$PATH:$HOME/.node_caches/bin"

export PATH

# }}}

# Envs {{{
#---------------------------------------------------------------------

export EDITOR=vim
export VISUAL=vim
export BROWSER=/usr/bin/firefox
export KUBE_EDITOR=vim

# Colors with less
# from: https://wiki.archlinux.org/index.php/Color_output_in_console#man
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;33m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;44;37m' # begin reverse video
export LESS_TERMCAP_us=$'\e[01;37m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline

export LESS='--mouse --wheel-lines=3'  # mouse support for less
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal
export MANPAGER='less -s -M +Gg'       # percentage FTW
export PAGER=$MANPAGER

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# NNN
export NNN_PLUG='e:-_vim $nnn*;n:-_vim notes*;f:fzcd;u:-getplugs;r:-launch'
export NNN_BMS='v:~/Videos;d:~/Documents;D:~/Downloads'
export NNN_CONTEXT_COLORS='2674'
[ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1"

# FZF
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='--multi --cycle --height 16 --color=dark --layout=reverse --prompt=" "'

# Android SDK
#export ANDROID_HOME=/usr/lib/android-sdk
export ANDROID_HOME=$HOME/android_sdk
export PATH=$PATH:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

# Deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$PATH:$DENO_INSTALL/bin"

# Go
export GOPATH=$HOME/code/go
export GOROOT=$HOME/go

# Wasmer
export WASMER_DIR="$HOME/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

# n (https://github.com/tj/n)
export N_PREFIX="$HOME/.node_caches"

# }}}

# Shell vars {{{
#---------------------------------------------------------------------

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

export HISTSIZE=1000
export HISTFILESIZE=2000
export HISTCONTROL=erasedups:ignorespace

export SYSTEMD_PAGER=

# }}}

# vim: ts=4 sw=4 sts=4 et fdm=marker:
