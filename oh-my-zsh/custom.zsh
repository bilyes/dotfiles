# vi key bindings
bindkey -v

# Paste with Ctrl-v
function zle-clipboard-paste {
  if ((REGION_ACTIVE)); then
    zle kill-region
  fi
  LBUFFER+="$(wl-paste)"
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

# fzf
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore .cache --ignore .npm --ignore .cargo -f -g "" --depth 10' # requires silversearch-ag
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_PREVIEW_CMD="cat {}"
source <(fzf --zsh)

export EDITOR=nvim
