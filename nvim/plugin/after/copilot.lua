vim.g.copilot_filetypes = { xml = false }
vim.g.copilot_no_tab_map = true

vim.keymap.set('i', '<C-a>', 'copilot#Accept("<CR>")', { silent = true, expr = true })
