#!/usr/bin/env zsh

if [[ -z $DISPLAY && $XDG_VTNR -eq 1 ]]; then
  if command -v dwm >/dev/null 2>&1; then
    exec startx "$XDG_CONFIG_HOME/X11/xinitrc" vt1
  else
    export ZSH_SYSTEM_CLIPBOARD_USE_WL_CLIPBOARD=1
    exec  niri-session -l
  fi
fi
