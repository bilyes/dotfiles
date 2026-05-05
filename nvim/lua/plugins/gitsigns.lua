return {
    'lewis6991/gitsigns.nvim',
    opts = {
        on_attach = function(bufnr)
            local gs = require('gitsigns')

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buf = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
            end, { expr = true, desc = 'Next hunk' })

            map('n', '[c', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
            end, { expr = true, desc = 'Previous hunk' })

            -- Actions
            map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>', { desc = 'Stage hunk' })
            map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>', { desc = 'Reset hunk' })
            map('n', '<leader>hS', gs.stage_buffer, { desc = 'Stage buffer' })
            map('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'Undo stage hunk' })
            --map('n', '<leader>hR', gs.reset_buffer)
            map('n', '<leader>hp', gs.preview_hunk, { desc = 'Preview hunk' })
            map('n', '<leader>hb', function() gs.blame_line { full = true } end, { desc = 'Blame line' })
            map('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'Toggle line blame' })
            map('n', '<leader>hd', function()
                if vim.wo.diff then
                    -- Close the diff view
                    vim.cmd('diffoff!')
                    for _, win in ipairs(vim.api.nvim_list_wins()) do
                        local buf = vim.api.nvim_win_get_buf(win)
                        if vim.api.nvim_buf_get_name(buf):match('^gitsigns://') then
                            vim.api.nvim_win_close(win, true)
                        end
                    end
                else
                    gs.diffthis()
                end
            end, { desc = 'Toggle diff' })
            map('n', '<leader>hD', function() gs.diffthis('~') end, { desc = 'Diff against ~' })
            map('n', '<leader>td', gs.toggle_deleted, { desc = 'Toggle deleted' })

            -- Text object
            --map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
    }
}
