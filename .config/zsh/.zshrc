#!/usr/bin/env zsh

HISTSIZE=10000
SAVEHIST=10000
if [[ ! -f ~/.cache/zsh/.histfile ]]; then
    mkdir -p ~/.cache/zsh
    touch ~/.cache/.histfile
fi
HISTFILE=~/.cache/zsh/.histfile

color="blue";
if [[ $USER == "root" ]]; then
    color="red";
fi
brackets="";
if [ ${IN_NIX_SHELL+1} ]; then
    brackets="[]"
fi
PS1=" %B${brackets:0:1} %F{${color}}%B%m%F{white}%B ${brackets:1:2}: %2~%F{white} >%b "

# vi mode
bindkey -v
export KEYTIMEOUT=1

source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/bindings"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases"

if [[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/shell/colors ]]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/colors"
fi

zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' list-colors 'di=1;36'
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**'
zstyle :compinstall filename '/home/mika/.config/zsh/.zshrc'

autoload -Uz compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -C

