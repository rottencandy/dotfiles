# Sample .bashrc for SuSE Linux
# Copyright (c) SuSE GmbH Nuernberg

# There are 3 different types of shells in bash: the login shell, normal shell
# and interactive shell. Login shells read ~/.profile and interactive shells
# read ~/.bashrc; in our setup, /etc/profile sources ~/.bashrc - thus all
# settings made here will also take effect in a login shell.
#
# NOTE: It is recommended to make language settings in ~/.profile rather than
# here, since multilingual X sessions would not work properly if LANG is over-
# ridden in every subshell.

export LC_CTYPE=en_US.UTF-8

# Some applications read the EDITOR variable to determine your favourite text
export EDITOR=/usr/bin/vim
export BROWSER=/usr/bin/firefox

# For some news readers it makes sense to specify the NEWSSERVER variable here
#export NEWSSERVER=your.news.server

# If you want to use a Palm device with Linux, uncomment the two lines below.
# For some (older) Palm Pilots, you might need to set a lower baud rate
# e.g. 57600 or 38400; lowest is 9600 (very slow!)
#
#export PILOTPORT=/dev/pilot
#export PILOTRATE=115200

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

test -s ~/.alias && . ~/.alias || true

# User specific environment
PATH="$HOME/.local/bin:$HOME/bin:$PATH"
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
export SYSTEMD_PAGER=

##################################################

# Disable  the insanely annoying ctrl-s and ctrl-q
stty -ixon

# cd into directory by typing directory name
shopt -s autocd

# Bash prompt
#export PS1=$"\[\033[48;5;2m\]\u@\h>\[$(tput sgr0)\]\[\033[48;5;8m\]\w \\$>\[$(tput sgr0)\]"
PS1="\[\e[42m\]\u\[\e[m\]\[\e[32;46m\]\[\e[m\]\[\e[37;46m\]\h\[\e[m\]\[\e[36;47m\]\[\e[m\]\[\e[30;47m\]\w\[\e[m\] "

# Git completion
#source /usr/share/bash-completion/completions/git

# Enable fzf shell bindings(fedora)
if [ -f /usr/share/fzf/shell/key-bindings.bash ]; then
    . /usr/share/fzf/shell/key-bindings.bash
fi
# Load fzf
#[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Node version manager
export NVM_DIR="$HOME/.nvm"
# loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Use gvim (better X, clipboard support)
alias vim='gvim -v'\
    t=tmux\
    g=git

# Kubernetes cl
export KUBE_EDITOR="vim"

# https://github.com/nvbn/thefuck
eval "$(thefuck --alias)"

