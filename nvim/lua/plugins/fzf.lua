return {
    { 'junegunn/fzf', build = "fzf#install()" },
    {
        'junegunn/fzf.vim',
        config = function()
            local opts = { noremap=true, silent=true }
            vim.keymap.set('n', '<tab>p', vim.cmd.Files, opts)
            vim.keymap.set('n', '<leader>fb', vim.cmd.Buffers, opts)
            vim.keymap.set('n', '<leader>fc', vim.cmd.Commits, opts)
            vim.keymap.set('n', '<leader>fl', vim.cmd.BLines, opts)
            vim.keymap.set('n', '<leader>fs', vim.cmd.Ag, opts)
        end
    },
}
