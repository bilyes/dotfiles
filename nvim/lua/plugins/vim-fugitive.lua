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
        vim.keymap.set('n', '<leader>gpu', function()
            local cur_branch = vim.trim(vim.fn.system('git rev-parse --abbrev-ref HEAD'))
            vim.cmd.Git('push -u origin ' .. cur_branch)
        end, opts('Git push upstream'))
        vim.keymap.set('n', 'gh', "<cmd>diffget //2<CR>", opts('Diffget from left'))
        vim.keymap.set('n', 'gl', "<cmd>diffget //3<CR>", opts('Diffget from right'))

        vim.opt.diffopt = vim.opt.diffopt + "vertical"
    end
}
