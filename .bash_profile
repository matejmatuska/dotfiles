# .bash_profile

# Get PATH setup
if [ -f ~/.profile ]; then
	. ~/.profile
fi

if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# Env variables
. "$HOME/.local/share/cargo/env"
