vim.g.mapleader = " "

local opts = { noremap=true, silent=true }

vim.keymap.set('i', 'jj', '<Esc>', opts)

vim.keymap.set('n', '<leader>h', ':wincmd h<CR>', opts)
vim.keymap.set('n', '<leader>j', ':wincmd j<CR>', opts)
vim.keymap.set('n', '<leader>k', ':wincmd k<CR>', opts)
vim.keymap.set('n', '<leader>l', ':wincmd l<CR>', opts)
--vim.keymap.set('n', '<leader>pv', ':Lex 28 <CR>', opts)
vim.keymap.set('n', '<leader>pa', ':set paste! <CR>', opts)
vim.keymap.set('n', '<leader>cd', ':cd %:p:h<CR> :pwd <CR>', opts)
vim.keymap.set('n', '<leader>du', ':sav %:p:h/', opts)

vim.keymap.set('n', 'oo', 'o<Esc>k', opts)
vim.keymap.set('n', 'OO', 'O<Esc>j', opts)
vim.keymap.set('n', 'Y', 'y$', opts)
vim.keymap.set('n', 'cY', '"*Y', opts)
vim.keymap.set('v', 'cy', '"*y', opts)
vim.keymap.set('n', 'cp', '"*p', opts)
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", opts)
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", opts)

-- preserve copied values across multiples pastes
vim.keymap.set('x', '<leader>p', '"_dP', opts) 

-- find and replace
vim.keymap.set('n', '<leader>sr', ':%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>', opts)

--vim.keymap.set('n', '<leader>u', ':UndotreeShow<CR>', opts)
