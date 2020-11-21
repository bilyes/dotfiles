#!/bin/bash

ln -s ~/configs/vim/.vim ~/ \
    && vim +PlugInstall +qall \
    && ~/.vim/plugged/YouCompleteMe/install.sh \
    && ln -s ~/configs/tmux.conf .tmux.conf
