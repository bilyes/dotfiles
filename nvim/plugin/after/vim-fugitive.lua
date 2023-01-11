vim.keymap.set('n', '<leader>gs', ':G<CR>', opts)
vim.keymap.set('n', '<leader>ggp', ':G push<CR>', opts)
vim.keymap.set('n', '<leader>gpf', ':G push -f<CR>', opts)
vim.keymap.set('n', '<leader>ggl', ':G pull<CR>', opts)
vim.keymap.set('n', '<leader>gpu', ':G push -u origin <C-R>=GetCurrentBranch()<CR><CR>', opts)
vim.keymap.set('n', '<leader>gcob', ':G checkout -b', opts)

