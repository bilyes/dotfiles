syntax on

set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu rnu
set nowrap
set smartcase
set ignorecase
"set noswapfile
"set nobackup
set undofile
set incsearch

set colorcolumn=100
highlight ColorColumn ctermbg=0 guibg=lightgrey

"Needed for vimwiki
set nocompatible
filetype plugin on

let g:vimwiki_list = [{'path': '~/vimwiki/',
                   \ 'syntax': 'markdown', 'ext': '.md'}]


"Set text width for text and markdown files
au BufEnter *.txt,*.md setl tw=80
