#!/bin/zsh

# source the plugins first, so that p10k instant prompt kicks in
source $ZDOTDIR/zsh_plugins.zsh

# XDG
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export PYTHONSTARTUP="$XDG_CONFIG_HOME"/python/pythonrc
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export XDG_CACHE_HOME="$HOME"/.cache

if [[ -e $HOME/.orbstack/shell/init.zsh ]]; then
	source ~/.orbstack/shell/init.zsh 2>/dev/null || :
fi
export LESSHISTFILE="$XDG_STATE_HOME"/less/history

export ANTHROPIC_API_KEY=$(cat ~/creds/claude)
export OPENROUTER_API_KEY=$(cat ~/creds/open_router)
export CARGO_HOME="$HOME/.cargo"
