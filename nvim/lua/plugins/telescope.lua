return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local opts = { noremap=true, silent=true }
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<tab>p', builtin.find_files, opts)
        vim.keymap.set('n', '<leader>fs', builtin.live_grep, opts)
        vim.keymap.set('n', '<leader>fb', builtin.buffers, opts)
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, opts)
    end,
}
