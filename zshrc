# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# append to the history file, don't overwrite it
setopt APPEND_HISTORY

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
SAVEHIST=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
# Already done by zsh

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
autoload -U colors && colors

if [[ "$TERM" == "xterm-color" || "$TERM" == *"-256color" ]]; then
    PS1="%{$fg_bold[green]%}%n@%m%{$reset_color%}:%{$fg_bold[blue]%}%~%{$reset_color%}\$ "
else
    PS1="%n@%m:%~\$ "
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="%{$terminfo[bold]$fg[green]%}%n@%m %{$fg[yellow]%}%~ %{$reset_color%}
\$ "
    ;;
*)
    ;;
esac

set -o vi

function subos_name()
{
    local -r uname=$(uname)

    if [[ $uname =~ .*[lL]inux.* ]]; then
        echo linux
    elif [[ $uname =~ .*CYGWIN_NT.* ]]; then
        echo cygwin
    else
        echo unknown
    fi
}

export SUB_OS=$(subos_name)

if [[ $SUB_OS == 'cygwin' ]]; then
    export CYGWIN_HOME=$(cygpath -m ~)
    export CYGWIN_USER=$(whoami)
    export LINUX_HOME=$(wsl wslpath -m '$(echo $HOME)')
    export LINUX_USER=$(wsl whoami)
elif [[ $SUB_OS == 'linux' ]]; then
    export CYGWIN_HOME=$(/mnt/c/cygwin64/bin/cygpath.exe -m '~' | sed 's@^[cC]:@/mnt/c@g')
    export CYGWIN_USER=$(/mnt/c/cygwin64/bin/whoami.exe)
    export LINUX_HOME=$(wslpath -m '~')
    export LINUX_USER=$(whoami)
else
    echo "unknown SUB_OS"
fi

export WIN_USER=$(basename $CYGWIN_HOME)

export PATH="$PATH":~/download/devenv/:/mnt/c/wsl-terminal/:/mnt/c/wsl-terminal/bin
export PATH="$PATH":~/download/wsl-utils/
export PATH="$PATH":~/.bin
export PATH="$PATH":~/.bin/wsl-utils
export PATH="$PATH":"/usr/local/lib/python3.8/dist-packages/"
export PATH="$PATH":~/.local/bin

export LANG="ja_JP.utf8"

# X setup
export DISPLAY=:0.0
bindkey "^I" menu-complete

export XDG_CONFIG_HOME=~/.config

autoload -Uz compinit && compinit
setopt GLOB_COMPLETE

source ~/.config/zsh_alias
