#!/usr/bin/env zsh


autoload colors && colors

HISTSIZE=10000
SAVEHIST=10000
if [[ ! -f ~/.cache/zsh/.histfile ]]; then
    mkdir -p ~/.cache/zsh
    touch ~/.cache/.histfile
fi
HISTFILE=~/.cache/zsh/.histfile
setopt inc_append_history

color="blue";
if [[ $USER == "root" ]]; then
    color="red";
fi
brackets="";
if [ ${IN_NIX_SHELL+1} ]; then
    brackets="[]"
fi
PS1=" %B${brackets:0:1} %F{${color}}%B%m%F{white}%B ${brackets:1:2}: %2~%F{white} >%b "

source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/bindings"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases"

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -C
_comp_options+=(globdots)

bindkey -v
export KEYTIMEOUT=1

if [[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/shell/colors ]]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/colors"
fi
