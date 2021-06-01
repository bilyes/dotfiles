# vi key bindings
bindkey -v

# Edit command
bindkey -M vicmd v edit-command-line

# remap Ctrl to Tab
bindkey '^I[' vi-cmd-mode
bindkey '^Iu' vi-kill-line

# autosuggest
bindkey '^I ' autosuggest-accept
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#536878"

# fzf
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -f -g "" --depth 10' # requires silversearch-ag
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
source /usr/share/doc/fzf/examples/key-bindings.zsh
#source /usr/share/fzf/completion.zsh

