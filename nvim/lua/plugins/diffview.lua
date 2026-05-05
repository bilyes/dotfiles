return {
    'sindrets/diffview.nvim',
    config = function()
        local function opts(desc)
            return { noremap = true, silent = true, desc = desc }
        end

        -- File history for current file
        vim.keymap.set('n', '<leader>gh', ':DiffviewFileHistory %<CR>', opts('File history (current file)'))
        -- Repo-wide file history
        vim.keymap.set('n', '<leader>gH', ':DiffviewFileHistory<CR>', opts('File history (repo)'))
        -- Diff working tree against HEAD
        vim.keymap.set('n', '<leader>gD', ':DiffviewOpen<CR>', opts('Diff working tree'))
        -- Close diffview
        vim.keymap.set('n', '<leader>gq', ':DiffviewClose<CR>', opts('Close diffview'))

        local actions = require('diffview.config').actions

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
            keymaps = {
                file_panel = {
                    { "n", "<leader>gr", actions.restore_entry, { desc = "Restore file to HEAD" } },
                },
            },
        })
    end
}
