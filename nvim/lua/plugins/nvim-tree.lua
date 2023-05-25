return {
    'kyazdani42/nvim-tree.lua',
    config = function()
        require('nvim-tree').setup({
            view = {
                width = 30,
            },
            actions = {
                open_file = {
                    quit_on_open = true
                }
            }
        })
        local opts = { noremap = true, silent = true }
        vim.keymap.set('n', '<leader>pv', vim.cmd.NvimTreeFindFileToggle, opts)
    end
}
