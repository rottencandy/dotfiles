# bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt

# Bash prompt
PS1="\[\e[42m\]\u\[\e[m\]\[\e[32;46m\]\[\e[m\]\[\e[30;46m\]\h\[\e[m\]\[\e[36;47m\]\[\e[m\]\[\e[30;47m\]\w\[\e[m\] "

# vim: ts=4 sw=4 sts=4 et fdm=marker:
