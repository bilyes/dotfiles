#!/bin/bash

cd ~

# Vim
(ln -s ~/.config/dotfiles/vim/.vim . && vim +PlugInstall +qall && .vim/plugged/YouCompleteMe/install.py) &

# Tmux
ln -s ~/.config/dotfiles/tmux.conf .tmux.conf &

# Oh-My-Zsh Auto suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &
ln -s ~/.config/dotfiles/oh-my-zsh/autosuggest.zsh ${ZSH_CUSTOM:-~/.oh-my-zsh/custom} &
sed -i 's/plugins=(/plugins=(zsh-autosuggestions /g' .zshrc &

ln -s ~/.config/dotfiles/alacritty .config/ &

wait
echo "Installation done"

