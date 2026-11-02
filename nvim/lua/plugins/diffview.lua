return {
    'sindrets/diffview.nvim',
    cmd = {
        'DiffviewOpen',
        'DiffviewClose',
        'DiffviewToggleFiles',
        'DiffviewFocusFiles',
        'DiffviewRefresh',
        'DiffviewFileHistory',
        'DiffviewLog',
    },
    keys = {
        -- File history for current file
        { '<leader>gh', ':DiffviewFileHistory %<CR>', desc = 'File history (current file)', silent = true },
        -- Repo-wide file history
        { '<leader>gH', ':DiffviewFileHistory<CR>',   desc = 'File history (repo)',         silent = true },
        -- Diff working tree against HEAD
        { '<leader>gD', ':DiffviewOpen<CR>',          desc = 'Diff working tree',           silent = true },
        -- Close diffview
        { '<leader>gq', ':DiffviewClose<CR>',         desc = 'Close diffview',              silent = true },
    },
    -- A function, so diffview.config is only required once diffview loads
    opts = function()
        local actions = require('diffview.config').actions

        return {
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
        }
    end,
}
