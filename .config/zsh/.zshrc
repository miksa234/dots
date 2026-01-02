#!/usr/bin/env zsh


autoload colors && colors

HISTSIZE=10000
SAVEHIST=10000
if [[ ! -f ~/.cache/zsh/.histfile ]]; then
    mkdir -p ~/.cache/zsh
    touch ~/.cache/zsh/.histfile
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

zstyle ':completion:*' completer _complete _ignored _expand _approximate _expand_alias
zstyle ':completion:*' list-colors 'di=1;36'
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**'
zstyle :compinstall filename '${XDG_CONFIG_HOME:-HOME/.config}/zsh/.zshrc'

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
if [ "$(date +'%j')" != "$(stat -f '%Sm' -t '%j' ~/.config/zsh/.zcompdump 2>/dev/null)" ]; then
    compinit
else
    compinit -C
fi
_comp_options+=(globdots)

bindkey -v
export KEYTIMEOUT=1

if [[ -f ${XDG_CONFIG_HOME:-$HOME/.config}/shell/colors ]]; then
    source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/colors"
fi
