require('nvim-tree').setup()
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>pv', vim.cmd.NvimTreeFindFileToggle, opts)
