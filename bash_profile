# .bash_profile

# Path exports {{{
#---------------------------------------------------------------------
test -s /etc/bashrc          && . /etc/bashrc
test -s $HOME/.bashrc        && . $HOME/.bashrc
test -s $HOME/.bash_aliases  && . $HOME/.bash_aliases

test -s $HOME/.local/bin     && PATH="$PATH:$HOME/.local/bin"
test -s $HOME/bin            && PATH="$PATH:$HOME/bin"
test -s $HOME/go/bin         && PATH="$PATH:$HOME/go/bin"
test -s $HOME/.cargo/bin     && PATH="$PATH:$HOME/.cargo/bin"

export PATH

# }}}
# Application environments {{{
#---------------------------------------------------------------------
export EDITOR=/usr/local/bin/vim
export BROWSER=/usr/bin/firefox
export KUBE_EDITOR=vim

export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
export XMODIFIERS="@im=fcitx"

# Colored man pages!!
export LESS_TERMCAP_mb=$'\E[01;31m'
export LESS_TERMCAP_md=$'\E[01;31m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;44;33m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;32m'

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# NNN options
export NNN_PLUG='e:-_vim $nnn*;n:-_vim /home/msaud/notes*;f:fzcd;u:-getplugs;r:-launch'
export NNN_BMS='v:~/Videos;d:~/Documents;D:~/Downloads'
export NNN_CONTEXT_COLORS='2674'
[ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1"

# FZF options
export FZF_DEFAULT_COMMAND='fdfind --type f --hidden'
if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    . /usr/share/doc/fzf/examples/key-bindings.bash
fi

# Node version manager
export NVM_DIR="$HOME/.nvm"
test -s "$NVM_DIR/nvm.sh"           && \. "$NVM_DIR/nvm.sh"
test -s "$NVM_DIR/bash_completion"  && \. "$NVM_DIR/bash_completion"

# Android SDK
#export ANDROID_HOME=$HOME/android_sdk
#export PATH=$PATH:$ANDROID_HOME/tools/bin
#export PATH=$PATH:$ANDROID_HOME/platform-tools

# }}}
# Shell options {{{
#---------------------------------------------------------------------
stty -ixon # Disable <C-s> & <C-q>
shopt -s autocd # cd on dir name
shopt -s checkwinsize #update LINES and COLUMNS on window resize
shopt -s cmdhist # combine multiline commands into one
shopt -s histappend
shopt -s globstar

export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_TYPE=en_US.UTF-8

export HISTSIZE=1000
export HISTFILESIZE=2000
export HISTCONTROL=erasedups

export SYSTEMD_PAGER=

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile)
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

# better less for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# }}}
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

# vim: ts=4 sw=4 sts=4 et fdm=marker:
