# Set dark title bars in kitty
if [ "$TERM" = "xterm-kitty" -a "$XDG_SESSION_TYPE" = "x11" ]; then
    xprop -id $WINDOWID -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT "dark"
fi

# don't pause the terminal output on ^S
stty -ixon

# git info in prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' actionformats '%F{3}%b%f:%F{1}%a%%f'
zstyle ':vcs_info:*' formats       '%F{3}%b%f %u%c'
zstyle ':vcs_info:*' check-for-changes 1
#zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{2}:%F{3}%r'

setopt prompt_subst
#PROMPT='%B%(1j.%F{red}*%f.)%F{14}%n@%m%f:%F{12}%~%f:%F{yellow}$(git_branch)%f%(!.#.$)%b '
PROMPT='%B%(1j.%F{red}*%f.)%F{12}%5(~/.../)%3~%f%(!.#.>)%b '
#RPROMPT='%(?.%F{green}✔%f.%F{red}✘%f)'
RPROMPT='${vcs_info_msg_0_} %(?.%F{green}0%f.%F{red}%?%f)'

#warn about suspended jobs when exiting
setopt CHECK_JOBS

function precmd {
    window_title="\033]0;${PWD}\007"
    print -Pn - '\e]0;%n@%m:%~\a'
    vcs_info
}


WORDCHARS=${WORDCHARS/\/}
WORDCHARS=${WORDCHARS/=}
#WORDCHARS=${WORDCHARS/-}

# History ---------------------------------------------------------------------
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
HISTSIZE=1000 # in session
SAVEHIST=10000 # in file

setopt HIST_IGNORE_ALL_DUPS
# share history across multiple zsh sessions
setopt SHARE_HISTORY
#setopt INC_APPEND_HISTORY # !! only when SHARE_HISTORY is not set !!
setopt HIST_IGNORE_SPACE

# Completion --------------------------------------------------------------
setopt COMPLETE_IN_WORD

fpath+=$ZDOTDIR/.zfunc
autoload -Uz compinit
zstyle ":completion:*" menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# better ssh, scp... completion
zstyle ':completion:*:(ssh|scp|ftp|sftp):*' hosts $hosts
zstyle ':completion:*:(ssh|scp|ftp|sftp):*' users $users
zmodload zsh/complist
compinit
_comp_options+=(globdots) # complete dotfiles

bindkey "\t" expand-or-complete-prefix

# KEYBINDS ----------------------------------------------------------------
bindkey -e # emacs keybinds, some of the below might be more redundant
# bind delete key to delete the next char
bindkey '\e[3~' delete-char
# arrow up/down searches in history if line is already started
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
# Ctrl + left/right
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[H" beginning-of-line # Home
bindkey "^[[F" end-of-line # End
# Bind shift-tab to backwards-menu
bindkey "\e[Z" reverse-menu-complete

autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

bindkey ' ' magic-space

if [ -r ~/.config/aliases ]; then
    source ~/.config/aliases
fi

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
