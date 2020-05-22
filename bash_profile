# .bash_profile

test -s $HOME/.bashrc        && . $HOME/.bashrc

# Path exports {{{
#---------------------------------------------------------------------

test -s $HOME/.local/bin          && PATH="$PATH:$HOME/.local/bin"
test -s $HOME/bin                 && PATH="$PATH:$HOME/bin"
test -s $HOME/go/bin              && PATH="$PATH:$HOME/go/bin"
test -s $HOME/.cargo/bin          && PATH="$PATH:$HOME/.cargo/bin"
test -s $HOME/.gem/ruby/2.5.0/bin && PATH="$PATH:$HOME/.gem/ruby/2.5.0/bin"

export PATH

# }}}

# Application environments {{{
#---------------------------------------------------------------------
export EDITOR=vim
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
export NNN_PLUG='e:-_vim $nnn*;n:-_vim notes*;f:fzcd;u:-getplugs;r:-launch'
export NNN_BMS='v:~/Videos;d:~/Documents;D:~/Downloads'
export NNN_CONTEXT_COLORS='2674'
export NVM_DIR="$HOME/.nvm"

# Fzf options
export FZF_DEFAULT_COMMAND='fdfind --type f'
export FZF_DEFAULT_OPTS='--multi --cycle --height 9 --color=dark --layout=reverse --prompt=" "'

# Android SDK
#export ANDROID_HOME=/usr/lib/android-sdk
export ANDROID_HOME=$HOME/android_sdk
export PATH=$PATH:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools

# Deno
export DENO_INSTALL="$HOME/.deno"
export PATH="$PATH:$DENO_INSTALL/bin"

#}}}

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
