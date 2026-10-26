# vi key bindings
bindkey -v

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
bindkey -M vicmd v edit-command-line

# remap Ctrl to Tab
bindkey '^I[' vi-cmd-mode
bindkey '^Iu' vi-kill-line

# autosuggest
bindkey '^I ' autosuggest-accept
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#536878"

export EDITOR=nvim

# Keep each PATH entry once: nested shells (e.g. each tmux pane) run this file again
typeset -U path
path+=("$HOME/.local/bin" "$HOME/.config/dotfiles/scripts")
