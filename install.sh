#!/bin/bash

cd ~ && ln -s ~/.config/dotfiles/vim/.vim . \
    && vim +PlugInstall +qall \
    && .vim/plugged/YouCompleteMe/install.py \
    && ln -s ~/.config/dotfiles/tmux.conf .tmux.conf
