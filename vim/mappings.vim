inoremap jj <Esc>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv

" Windows
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>pv :wincmd v<CR> :Ex <bar> :vertical resize 30 <CR>

" Search
nnoremap <leader>ps :Rg<SPACE>

" YCM
nnoremap <silent> <leader>gd :YcmCompleter GoTo<CR>
"nnoremap <silent> <leader>gf :YcmCompleter FixIt<CR>
nnoremap <silent> <leader>gr :YcmCompleter GoToReferences<CR>
nnoremap <silent> <leader>rr :YcmCompleter RefactorRename<CR>

" FZF
nnoremap <C-i>p :Files<CR>
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
"let g:fzf_layout = { 'down': '40%' }

" GIT
nnoremap <leader>gs :G<CR>

" Change directory to current file's directory
nnoremap <leader>cd :cd %:p:h<CR> :pwd <CR>
nnoremap <leader>du :sav %:p:h/

nnoremap oo o<Esc>k
nnoremap OO O<Esc>j
nnoremap Y y$

" Copy to system register (clipboard)
" + is the system register
"nnoremap <leader>y "+y<CR>

"Vimwiki
nmap <leader>x <Plug>VimwikiToggleListItem h
