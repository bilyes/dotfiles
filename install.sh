#!/bin/bash

cd ~ && ln -s ~/$CONFIG_FOLDER/vim/.vim . \
    && vim +PlugInstall +qall \
    && .vim/plugged/YouCompleteMe/install.py \
    && ln -s ~/$CONFIG_FOLDER/tmux.conf .tmux.conf
