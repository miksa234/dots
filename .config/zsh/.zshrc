#!/usr/bin/zsh
# *-* zshrc *-*

HISTFILE=~/.cache/zsh/.histfile
HISTSIZE=10000
SAVEHIST=10000

autoload -U colors && colors
autoload -U compinit

#256
#color=$( ( shuf -i 52-57 && shuf -i 88-99 && shuf -i 124-135 && shuf -i 160-177 ) | shuf -n 1)
#PS1=" %F{white}%B%2~ %F{$color} Ψ %F{white} >%b "
PS1=" %F{white}%B%2~%F{white} >%b "

# vi mode
bindkey -v
export KEYTIMEOUT=1


# The following lines were added by compinstall
zstyle ':completion:*' completer _complete _ignored
zstyle ':completion:*' list-colors 'di=1;36'
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**'
zstyle :compinstall filename '/home/mika/.config/zsh/.zshrc'

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit

source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/vimode"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/colors"
