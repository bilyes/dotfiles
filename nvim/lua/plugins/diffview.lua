return {
    'sindrets/diffview.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local opts = { noremap = true, silent = true }

        -- File history for current file
        vim.keymap.set('n', '<leader>gh', ':DiffviewFileHistory %<CR>', opts)
        -- Repo-wide file history
        vim.keymap.set('n', '<leader>gH', ':DiffviewFileHistory<CR>', opts)
        -- Diff working tree against HEAD
        vim.keymap.set('n', '<leader>gD', ':DiffviewOpen<CR>', opts)
        -- Close diffview
        vim.keymap.set('n', '<leader>gq', ':DiffviewClose<CR>', opts)

        require('diffview').setup({
            file_panel = {
                win_config = function()
                    if vim.o.columns < 120 then
                        return { type = "split", position = "bottom", height = 15 }
                    else
                        return { type = "split", position = "left", width = 35 }
                    end
                end,
            },
        })
    end
}
