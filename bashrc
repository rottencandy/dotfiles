# bashrc

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

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

# Shell options {{{
#---------------------------------------------------------------------

stty -ixon # Disable <C-s> & <C-q>
shopt -s autocd # cd on dir name
#shopt -s cdspell # automatically correct minor typos with dir names
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

# Functions {{{
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

    nnn -crA "$@"

    if [ -f "$NNN_TMPFILE" ]; then
        . "$NNN_TMPFILE"
        rm -f "$NNN_TMPFILE" > /dev/null
    fi
}

# yazi with cd on quit
y ()
{
    tmp="$(mktemp -t "yazi-cwd.XXXXX")"
    yazi --cwd-file="$tmp"
    if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        cd -- "$cwd"
    fi
    rm -f -- "$tmp"
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
    local fzfcmd="fd -Hd 1"
    local cmd=nvim
    if [ $# -eq 1 ]
    then
        cmd=$1
    elif [ $# -eq 2 ]
    then
        fzfcmd="fd -Hd $1"
        cmd=$2
    fi
    local file=$($fzfcmd | fzf) || return
    $cmd "$file"
}

# ftpane - switch pane (@george-b)
# bind f run "tmux split-window -v -l 10 'bash -ci ftpane'"
tmux_fzf_pane() {
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

# Grab a password from the password store into the clipboard using fzf
getp() {
    local PASS_DIR=~/.password-store
    local selection=$(cd $PASS_DIR && fd --type f | fzf)
    if [ -z $selection ]; then return; fi
    pass -c "${selection//.gpg/}"
}

# https://gist.github.com/pcdv
g() {
    local HLP="Bookmark your favorite directories:
    g         : list bookmarked dirs
    g .       : add current dir to bookmarks
    g -e      : edit bookmarks
    g <num>   : jump to n-th dir
    g <regex> : jump to 1st matching dir"
    local D=_; local CFG="$HOME/.cdirs"

    case $1 in
        #"") [ -f "$CFG" ] && nl "$CFG" || echo "$HLP" ;;
        "") [ -f "$CFG" ] && D=$(cat "$CFG" | fzf) || D=_ ;;
        .) pwd >> "$CFG" ;;
        -e) ${EDITOR:-vi} "$CFG" ;;
        -*) echo "$HLP" ;;
        [1-9]*) D=$(sed -ne "${1}p" "$CFG") ;;
        *) D=$(grep "$1" "$CFG" | head -1) ;;
    esac

    if [ "$D" != _ ]; then 
        [ -d "$D" ] && cd "$D" || echo "Not found"
    fi
}

installcmd() {
    local HLP="Interactively download, extract and install a binary from provided URL."
    local TMPDIR=~/installcmd_dir
    mkdir -p $TMPDIR && pushd $TMPDIR
    case "$1" in
        "") echo $HLP ;;
        *.tar.gz | *.tar.xz | *.tbz)
            local ARC=archive.tar.gz
            xh -d "$1" -o $ARC || return 1
            tar -xf $ARC
            ;;
        *.gz)
            local ARC="${2:-archive.gz}"
            xh -d "$1" -o $ARC || return 1
            gunzip $ARC
            ;;
        *.zip)
            local ARC=archive.zip
            xh -d "$1" -o $ARC || return 1
            unzip $ARC
            ;;
        *.apk)
            local ARC=archive.apk
            xh -d "$1" -o $ARC || return 1
            tar -xf $ARC
            ;;
        *)
            xh -d "$1"
            # xh adds .bin to downloaded files by default
            for i in ./*.bin ; do mv "$i" "${i%.*}" ; done
    esac
    if [ -z $(ls -A $TMPDIR) ]; then
        # dir is empty, download didn't happen
        popd && rm -r $TMPDIR
        return;
    fi
    echo "Select binary:"
    local BINARY=$(fzf)
    if [ -z $BINARY ]; then return; fi
    echo "Installing..."
    chmod +x $BINARY
    cp $BINARY ~/bin
    popd && rm -r $TMPDIR
    echo "Successfully installed and cleaned up"
}

# }}}

# Mappings {{{

# FZF + git
is_in_git_repo() {
    git rev-parse HEAD > /dev/null 2>&1
}

_fzf_down() {
    fzf --height 50% "$@" --border
}

_gb() {
    is_in_git_repo || return
    git branch -a --color=always | grep -v '/HEAD\s' | sort |
        _fzf_down --ansi --multi --tac --preview-window right:70% \
        --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' |
        sed 's/^..//' | cut -d' ' -f1 |
        sed 's#^remotes/##'
    }
bind '"\C-g\C-b": "$(_gb)\e\C-e\er"'

_gt() {
    is_in_git_repo || return
    git tag --sort -version:refname |
        _fzf_down --multi --preview-window right:70% \
        --preview 'git show --color=always {}'
    }
bind '"\C-g\C-t": "$(_gt)\e\C-e\er"'

_gs() {
    is_in_git_repo || return
    git stash list | _fzf_down --reverse -d: --preview 'git show --color=always {1}' |
        cut -d: -f1
    }
bind '"\C-g\C-s": "$(_gs)\e\C-e\er"'

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
        egrep='grep -E --color=auto'
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
    xscrt='maim -g $(slop -q) screenshot-$(date +%s).png 2> /dev/null' \
    scrt='grim -g "$(slurp)" screenshot-$(date +%s).png 2> /dev/null' \
    srec='wf-recorder -g "$(slurp)" -c h264_vaapi -d /dev/dri/renderD128 -f recording-$(date +%s).mp4' \
    arec='parec --monitor-system="$(pacmd get-default-source)" --file-format="wav" recording-$(date +%s).wav' \
    t='tmux' \
    tree='lsd --tree' \
    ungr='gron --ungron' \
    v='vim -X' \
    yt='yt-dlp --add-metadata -i' \
    ytb='yt-dlp --add-metadata -i -f bestvideo+bestaudio' \
    yta='yt --add-metadata -x -f bestaudio' \
    camfeed='gst-launch-1.0 -v v4l2src device=/dev/video0 ! glimagesink' \
    brownnoise='play -n synth brownnoise synth pinknoise mix synth sine amod 0.3 10' \
    whitenoise='play -q -c 2 -n synth brownnoise band -n 1600 1500 tremolo .1 30' \
    pinknoise='play -t sl -r48000 -c2 -n synth -1 pinknoise .1 80' \
    dnf='dnf -C' \
    ng='nixGLIntel'

_completion_loader sudo tmux
complete -F _sudo s
complete -F _tmux t

# }}}

# Path exports {{{
#---------------------------------------------------------------------

test -s $HOME/.local/bin          && PATH="$PATH:$HOME/.local/bin"
test -s $HOME/.local/sbin         && PATH="$PATH:$HOME/.local/sbin"
test -s $HOME/bin                 && PATH="$PATH:$HOME/bin"
test -s $HOME/.scripts            && PATH="$PATH:$HOME/.scripts"
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
export GIT_EDITOR=vim
export SVN_EDITOR=vim
export KUBE_EDITOR=vim
export VISUAL=vim
export BROWSER=/usr/bin/firefox

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
export NNN_OPENER="open"

# FZF
export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_DEFAULT_OPTS='--multi --cycle --height 16 --color=dark --layout=reverse --prompt=" " --bind "ctrl-k:toggle-preview"'

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

# broot
[ -s ~/.config/broot/launcher/bash/br ] && source ~/.config/broot/launcher/bash/br

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$PATH:$BUN_INSTALL/bin"

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

export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
export XMODIFIERS="@im=fcitx"

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

#PS1="${BLUE}(${GREEN}\w${BLUE}) ${RED}\$ ${NORMAL}"

eval "$(starship init bash)"

# }}}

# vim: ts=4 sw=4 sts=4 et fdm=marker fdl=0:
