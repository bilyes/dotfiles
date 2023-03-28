require('nvim-tree').setup({
    actions = {
        open_file = {
            quit_on_open = true
        }
    }
})
local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>pv', vim.cmd.NvimTreeFindFileToggle, opts)
