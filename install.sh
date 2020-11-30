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

# Alacritty
ln -s ~/.config/dotfiles/alacritty ~/.config/ &

# Powerline
(pip install powerline-status && pip install powerline-mem-segment) &
ls -s ~/.config/dotfiles/powerline ~/.config/ &
echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.zshrc


wait
echo "Installation done"

