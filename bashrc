# bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# sources {{{
#---------------------------------------------------------------------
test -s /etc/bashrc          && . /etc/bashrc

# FZF options
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    . /usr/share/doc/fzf/examples/key-bindings.bash
fi

# Node version manager
export NVM_DIR="$HOME/.nvm"
test -s "$NVM_DIR/nvm.sh"           && \. "$NVM_DIR/nvm.sh"
test -s "$NVM_DIR/bash_completion"  && \. "$NVM_DIR/bash_completion"


# }}}

# Prompt {{{
#---------------------------------------------------------------------
# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
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

if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

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

# select file using fzf with max recursive depth
fld() {
    if [ $# -eq 0 ]
    then
        vim "$(fd -Hd 1 | fzf)"
    elif [ $# -eq 1 ]
    then
        $1 "$(fd -Hd 1 | fzf)"
    elif [ $# -eq 2 ]
    then
        $2 "$(fd -Hd $1 | fzf)"
    fi
}

# ftpane - switch pane (@george-b)
# bind-key 0 run "tmux split-window -l 12 'bash -ci ftpane'"
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
    ll='ls -l' \
    la='ls -A' \
    l='ls -CF' \
    t='tmux' \
    v='vim' \
    nv='nvim' \
    g='git' \
    k='kubectl' \
    yt="youtube-dl --add-metadata -i" \
    yta="yt --add-metadata -x -f bestaudio" \
    nc="ncmpcpp" \
    tree="lsd --tree"

# }}}

# Path exports {{{
#---------------------------------------------------------------------

test -s $HOME/.local/bin          && PATH="$PATH:$HOME/.local/bin"
test -s $HOME/bin                 && PATH="$PATH:$HOME/bin"
test -s $HOME/go/bin              && PATH="$PATH:$HOME/go/bin"
test -s $HOME/.cargo/bin          && PATH="$PATH:$HOME/.cargo/bin"
test -s $HOME/.gem/ruby/2.5.0/bin && PATH="$PATH:$HOME/.gem/ruby/2.5.0/bin"

export PATH

# }}}

# Envs {{{
#---------------------------------------------------------------------

export EDITOR=vim
export BROWSER=/usr/bin/firefox
export KUBE_EDITOR=vim

export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
export XMODIFIERS="@im=fcitx"

# Colors with less
# from: https://wiki.archlinux.org/index.php/Color_output_in_console#man
export LESS_TERMCAP_mb=$'\e[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\e[1;33m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;44;37m' # begin reverse video
export LESS_TERMCAP_us=$'\e[01;37m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'        # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'        # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal
export MANPAGER='less -s -M +Gg'       # percentage FTW

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# NNN
export NNN_PLUG='e:-_vim $nnn*;n:-_vim notes*;f:fzcd;u:-getplugs;r:-launch'
export NNN_BMS='v:~/Videos;d:~/Documents;D:~/Downloads'
export NNN_CONTEXT_COLORS='2674'
[ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1"

# FZF
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='--multi --cycle --height 9 --color=dark --layout=reverse --prompt=" "'

# Android SDK
#export ANDROID_HOME=/usr/lib/android-sdk
export ANDROID_HOME=$HOME/android_sdk
export PATH=$PATH:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

# Deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$PATH:$DENO_INSTALL/bin"

# }}}

# Shell options {{{
#---------------------------------------------------------------------

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

export HISTSIZE=1000
export HISTFILESIZE=2000
export HISTCONTROL=erasedups

export SYSTEMD_PAGER=

# }}}

# vim: ts=4 sw=4 sts=4 et fdm=marker:
