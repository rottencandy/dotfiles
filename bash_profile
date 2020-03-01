# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User-specific binaries
export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# Go
export PATH="$PATH:$HOME/go/bin"

# User specific environment and startup programs
#eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

export PATH="$HOME/.cargo/bin:$PATH"

# Input method
export GTK_IM_MODULE="fcitx"
export QT_IM_MODULE="fcitx"
export XMODIFIERS="@im=fcitx"

export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
