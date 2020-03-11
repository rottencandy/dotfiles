# bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# Env sources {{{
#---------------------------------------------------------------------
test -s /etc/bashrc          && . /etc/bashrc
test -s $HOME/.bash_aliases  && . $HOME/.bash_aliases

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

# Application environments {{{
#---------------------------------------------------------------------

# NNN options
[ -n "$NNNLVL" ] && PS1="N$NNNLVL $PS1"

# FZF options
export FZF_DEFAULT_COMMAND='fdfind --type f --hidden'
if [ -f /usr/share/doc/fzf/examples/key-bindings.bash ]; then
    . /usr/share/doc/fzf/examples/key-bindings.bash
fi

# Node version manager
test -s "$NVM_DIR/nvm.sh"           && \. "$NVM_DIR/nvm.sh"
test -s "$NVM_DIR/bash_completion"  && \. "$NVM_DIR/bash_completion"

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

# do sudo, or sudo the last command if no argument given
s() {
    if [[ $# == 0 ]]; then
        echo sudo $(history -p '!!')
        sudo $(history -p '!!')
    else
        sudo "$@"
    fi
}

# vim: ts=4 sw=4 sts=4 et fdm=marker:
