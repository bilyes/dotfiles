vim.g.copilot_filetypes = { xml = false }
vim.g.copilot_no_tab_map = true

local opts = { silent = true, noremap = true, expr = true }
vim.keymap.set('i', '<C-a>', 'copilot#Accept("<CR>")', opts)
vim.keymap.set('i', '<C-f>', 'copilot#Next()', opts)
vim.keymap.set('i', '<C-s>', 'copilot#Previous()', opts)
