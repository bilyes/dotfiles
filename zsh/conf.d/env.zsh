export EDITOR=nvim

# Keep each PATH entry once: nested shells (e.g. each tmux pane) run this file again.
# install.sh links this repo's scripts into ~/.local/bin.
typeset -U path
path+=("$HOME/.local/bin")
