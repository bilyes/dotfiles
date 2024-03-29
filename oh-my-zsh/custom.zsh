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
export FZF_DEFAULT_COMMAND='ag --hidden --ignore .git --ignore .cache --ignore .npm -f -g "" --depth 10' # requires silversearch-ag
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_PREVIEW_CMD="cat {}"

# install fzf by cloning the git repo and running: ./install --xdg --no-bash --no-fish
#source $HOME/.config/fzf/fzf.zsh

# OR install through apt and

source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh
