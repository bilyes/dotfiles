#!/bin/bash

function link-folder() {
    if [ -z "$1" ]; then
        echo "Error: No folder to link. Usage: link-folder /path/to/folder"
    else
        ln -s ~/.config/dotfiles/$1 ~/.config/
    fi
}

cd ~

# Vim
(ln -s ~/.config/dotfiles/vim/.vim . && vim +PlugInstall +qall && .vim/plugged/YouCompleteMe/install.py) &

# Oh-My-Zsh Auto suggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &
ln -s ~/.config/dotfiles/oh-my-zsh/autosuggest.zsh ${ZSH_CUSTOM:-~/.oh-my-zsh/custom} &
sed -i 's/plugins=(/plugins=(zsh-autosuggestions /g' .zshrc &

link-folder alacritty &
link-folder tmux &
link-folder powerline &

echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.zshrc

wait
echo "Installation done"

