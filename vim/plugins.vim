call plug#begin($XDG_DATA_HOME.'/vim/plugged')
" Themes
"Plug 'morhetz/gruvbox'
Plug 'arcticicestudio/nord-vim'

Plug 'jremmen/vim-ripgrep'
Plug 'tpope/vim-fugitive'
"Plug 'leafgarland/typescript-vim'
Plug 'vim-utils/vim-man'
Plug 'lyuts/vim-rtags'
"Plug 'kien/ctrlp.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
"Plug 'ycm-core/YouCompleteMe'
Plug 'mbbill/undotree'
Plug 'preservim/nerdcommenter'
" Auto pairs for '[', '{' and '('
Plug 'jiangmiao/auto-pairs'
" Debugging
Plug 'puremourning/vimspector'
Plug 'szw/vim-maximizer'
Plug 'vim-airline/vim-airline'
"Plug 'vim-airline/vim-airline-themes'
Plug 'vimwiki/vimwiki'

" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'

"Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

call plug#end()
