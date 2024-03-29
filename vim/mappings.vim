inoremap jj <Esc>
vnoremap J :m '>+1<CR>gv=gv
vnoremap K :m '<-2<CR>gv=gv
nnoremap <leader>so :so ~/.config/vim/vimrc<CR>
nnoremap <leader>sr :%s/\<<C-r><C-w>\>//gI<Left><Left><Left>

" Windows
nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <leader>u :UndotreeShow<CR>
nnoremap <leader>pv :wincmd v<CR> :Ex <bar> :vertical resize 30 <CR>
nnoremap <leader>pa :set paste! <CR>

" Search
nnoremap <leader>ps :Rg<SPACE>

" YCM
nnoremap <silent> <leader>gd :YcmCompleter GoTo<CR>
"nnoremap <silent> <leader>gf :YcmCompleter FixIt<CR>
nnoremap <silent> <leader>gr :YcmCompleter GoToReferences<CR>
nnoremap <silent> <leader>rr :YcmCompleter RefactorRename<CR>

" FZF
nnoremap <tab>p :Files<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fc :Commits<CR>
nnoremap <leader>fl :BLines<CR>
let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
"let g:fzf_layout = { 'down': '40%' }

" GIT
function! g:GetCurrentBranch() abort
    let cur_branch=system('git rev-parse --abbrev-ref HEAD | tr -d "\n"')
    return cur_branch
endfunction

nnoremap <leader>gs :G<CR>
nnoremap <leader>ggp :G push<CR>
nnoremap <leader>gpf :G push -f<CR>
nnoremap <leader>ggl :G pull<CR>
nnoremap <leader>gpu :G push -u origin <C-R>=GetCurrentBranch()<CR><CR>
nnoremap <leader>gcob :G checkout -b 

" Change directory to current file's directory
nnoremap <leader>cd :cd %:p:h<CR> :pwd <CR>
nnoremap <leader>du :sav %:p:h/

nnoremap oo o<Esc>k
nnoremap OO O<Esc>j
nnoremap Y y$
nnoremap cY "+Y
vnoremap cy "+y
nnoremap cp "+p

" Copy to system register (clipboard)
" + is the system register
"nnoremap <leader>y "+y<CR>

" Vimwiki
nmap <leader>x <Plug>VimwikiToggleListItem h

" Vimspector
nnoremap <leader>dd :call vimspector#Launch()<CR>
nnoremap <leader>dx :VimspectorReset<CR>
nnoremap <leader>db :call vimspector#ToggleBreakpoint()<CR>
nnoremap <leader>dlb :call vimspector#ListBreakpoints()<CR>
nnoremap <leader>dsn :call vimspector#StepOver()<CR>
nnoremap <leader>dsi :call vimspector#StepInto()<CR>
nnoremap <leader>dso :call vimspector#StepOut()<CR>
