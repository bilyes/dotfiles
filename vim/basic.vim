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
set undofile
set incsearch
" don't require buffers to be saved before navigating away from them
set hidden
set scrolloff=8
"set signcolumn=yes

set foldmethod=syntax
set foldnestmax=1
set nofoldenable

set colorcolumn=100
highlight ColorColumn ctermbg=0 guibg=lightgrey

"Needed for vimwiki
set nocompatible
filetype plugin on

let g:vimwiki_list = [{'path': '~/wikis/main', 'syntax': 'markdown', 'ext': '.md'},
            \ {'path': '~/wikis/knowledge', 'syntax': 'markdown', 'ext': '.md'},
            \ {'path': '~/wikis/blog', 'syntax': 'markdown', 'ext': '.md'}]


" Fugitive git diff orientation
set diffopt+=vertical

"Set text width for text and markdown files
au BufEnter *.txt,*.md setl tw=80

"YCM
"let g:ycm_autoclose_preview_window_after_completion = 1
"let g:ycm_key_list_select_completion = ['<C-j>']
"let g:ycm_key_list_previous_completion = ['<C-k>']

" Ultisnips
let g:UltiSnipsExpandTrigger="<s-tab>"
"let g:UltiSnipsListSnippets="<c-s-tab>"

" Vimspector
let g:vimspector_install_gadgets = [ 'delve' ]
