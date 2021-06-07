#!/bin/bash

function link-folder() {
    if [ -z "$1" ]; then
        echo "Error: No folder to link. Usage: link-folder /path/to/folder"
    else
        ln -s ~/.config/dotfiles/$1 ~/.config/
    fi
}

function link-zsh() {
    if [ -z "$1" ]; then
        echo "Error: No file to link. Usage: link-zsh /path/to/file"
    else
        ln -s ~/.config/dotfiles/oh-my-zsh/$1 ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}
    fi
}

cd ~

ln -s ~/.config/dotfiles/.xprofile . &
source ~/.config/dotfiles/.xprofile

# Vim
(link-folder vim && vim +PlugInstall +qall && $XDG_DATA_HOME/vim/plugged/YouCompleteMe/install.py) &

# Oh-My-Zsh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions &
sed -i 's/plugins=(/plugins=(zsh-autosuggestions /g' .zshrc &
link-zsh custom.zsh
link-zsh aliases.zsh
link-zsh functions.zsh

#link-folder alacritty &
link-folder powerline &
link-folder rofi &
link-folder termite &
link-folder tmux &
link-folder picom &
link-folder i3 &

echo 'export PATH=$PATH:$HOME/.local/bin' >> ~/.zshrc

wait
echo "Installation done"

