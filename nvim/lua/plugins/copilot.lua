return {
    'github/copilot.vim',
    config = function()
        vim.g.copilot_filetypes = {
            markdown = false,
            lua = true,
            java = true,
            go = true,
            yaml = true,
            typescript = true,
        }
        vim.g.copilot_no_tab_map = true

        local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
        vim.keymap.set('i', '<C-a>', 'copilot#Accept("<CR>")', opts)
        vim.keymap.set('i', '<C-f>', 'copilot#Next()', opts)
        vim.keymap.set('i', '<C-s>', 'copilot#Previous()', opts)
    end
}
