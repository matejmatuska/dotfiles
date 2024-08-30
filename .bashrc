# .bashrc

# Set dark title bars in kitty
if [ "$TERM" = "xterm-kitty" -a "$XDG_SESSION_TYPE" = "x11"]; then
    xprop -id $WINDOWID -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT "dark"
fi

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# History variables are not env variables
HISTCONTROL=ignoredups
HISTFILESIZE=10000

# Git prompt
GIT_PROMPT=/usr/share/doc/git/contrib/completion/git-prompt.sh
source "$GIT_PROMPT"
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWCOLORHINTS=1

#export PROMPT_COMMAND='__git_ps1 "\[\e[96m\]\u@\h\[\e[00m\]:\[\e[94m\]\w\[\e[00m\]" "\$ "'

PS1='\[\e[01;96m\]\u@\h\[\e[00m\]:\[\e[01;94m\]\w\[\e[00m\]$(__git_ps1 " (%s)")\$ '

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

alias vim="nvim"
alias ip='ip --color'

# When quitting ranger do not return to a directory where ranger was launched,
# instead return to a current ranger directory
alias ranger='ranger --choosedir=$HOME/.rangerdir; LASTDIR=`cat $HOME/.rangerdir`; cd "$LASTDIR"'

source  "$HOME/.local/share/cargo/env"
