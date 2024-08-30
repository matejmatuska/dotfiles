# Get PATH setup
if [ -f ~/.profile ]; then
    . ~/.profile
fi

# Env variables
export VISUAL="nvim"
export EDITOR=$VISUAL
export TERMINAL="alacritty"

# cleanup $HOME
export LESSKEY="$XDG_CONFIG_HOME"/less/lesskey
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history

export GRADLE_USER_HOME="$XDG_DATA_HOME"/gradle
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup

export SSH_AUTH_SOCK=$XDG_RUNTIME_DIR/gcr/ssh

[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"
