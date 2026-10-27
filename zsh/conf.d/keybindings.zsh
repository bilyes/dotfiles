# vi mode itself is selected in zsh/zshrc, before this folder loads.

# Paste with Ctrl-v
function zle-clipboard-paste {
  if ((REGION_ACTIVE)); then
    zle kill-region
  fi
  if [[ "$OSTYPE" == "darwin"* ]]; then
    LBUFFER+="$(pbpaste)"
  elif [[ -n "$WAYLAND_DISPLAY" ]]; then
    LBUFFER+="$(wl-paste)"
  fi
}
zle -N zle-clipboard-paste

bindkey '^V' zle-clipboard-paste

# Edit command
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

# remap Ctrl to Tab
bindkey '^I[' vi-cmd-mode
bindkey '^Iu' vi-kill-line

# autosuggest
bindkey '^I ' autosuggest-accept
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#536878"
# Wrap widgets once, at the first prompt, instead of before every prompt (~5ms each).
# Widgets defined later in a session aren't wrapped.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
