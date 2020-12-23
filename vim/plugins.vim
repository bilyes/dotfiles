call plug#begin($XDG_DATA_HOME.'/vim/plugged')
"Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'
Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
Plug 'leafgarland/typescript-vim'
Plug 'vim-utils/vim-man'
Plug 'lyuts/vim-rtags'
"Plug 'kien/ctrlp.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ycm-core/YouCompleteMe'
Plug 'mbbill/undotree'
Plug 'preservim/nerdcommenter'
" Auto pairs for '[', '{' and '('
Plug 'jiangmiao/auto-pairs'
" Debugging
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'
Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
call plug#end()
