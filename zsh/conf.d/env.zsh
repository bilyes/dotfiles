export EDITOR=nvim

# Keep each PATH entry once: nested shells (e.g. each tmux pane) run this file again
typeset -U path
path+=("$HOME/.local/bin" "$HOME/.config/dotfiles/scripts")
