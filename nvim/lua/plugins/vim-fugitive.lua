return {
    'tpope/vim-fugitive',
    config = function()
        local function opts(desc)
            return { noremap = true, silent = true, desc = desc }
        end

        vim.keymap.set('n', '<leader>gs', vim.cmd.Git, opts('Git status'))
        vim.keymap.set('n', '<leader>ggp', function() vim.cmd.Git('push') end, opts('Git push'))
        vim.keymap.set('n', '<leader>gpf', function() vim.cmd.Git('push -f') end, opts('Git push force'))
        vim.keymap.set('n', '<leader>ggl', function() vim.cmd.Git('pull') end, opts('Git pull'))
        vim.keymap.set('n', '<leader>gcob', ':G checkout -b ', opts('Git checkout new branch'))
        -- Rebind fugitive's d2o/d3o (ours/theirs hunk in a merge diff) to gh/gl.
        vim.g.nremap = { d2o = 'gh', d3o = 'gl' }

        vim.opt.diffopt = vim.opt.diffopt + "vertical"
    end
}
