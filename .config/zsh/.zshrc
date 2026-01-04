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

[[ -a $(which direnv) ]] && eval "$(direnv hook zsh)"

color="blue"; [[ $USER =~ "root" ]] && color="red"
brackets=""; [[ -v ${IN_NIX_SHELL} ]] && brackets="[]"

PS1=" %B${brackets:0:1} %F{${color}}%B%m%F{white}%B ${brackets:1:2}: %2~%F{white} >%b "

source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/bindings"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases"

for p in ${(z)NIX_PROFILES}; do
    fpath=(
        $p/share/zsh/site-functions
        $p/share/zsh/$ZSH_VERSION/functions
        $p/share/zsh/vendor-completions
        $fpath
    )
done

zstyle ':completion:*' completer _complete _ignored _expand _approximate _expand_alias
zstyle ':completion:*' list-colors 'di=1;36'
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**'
zstyle :compinstall filename '${XDG_CONFIG_HOME:-HOME/.config}/zsh/.zshrc'
zstyle ':completion:*' menu select

autoload -U compinit
zmodload zsh/complist
if [[ ! -f ~/.config/zsh/.zcompdump ]]; then
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
