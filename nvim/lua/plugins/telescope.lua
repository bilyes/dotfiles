return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local opts = { noremap = true, silent = true }
        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<tab>p', builtin.find_files, opts)
        vim.keymap.set('n', '<leader>fs', builtin.live_grep, opts)
        vim.keymap.set('n', '<leader>fb', builtin.buffers, opts)
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, opts)
        vim.keymap.set('n', '<leader>fr', builtin.lsp_references, opts)
        vim.keymap.set('n', '<leader>fi', builtin.lsp_implementations, opts)
        vim.keymap.set('n', '<leader>ds', builtin.lsp_document_symbols, opts)
        vim.keymap.set('n', '<leader>fw', builtin.grep_string, opts)

        require('telescope').setup {
            defaults = {
                layout_strategy = 'vertical',
                path_display = {
                    shorten = {
                        len = 3,
                        exclude = { -1, -2 }, -- exclude the last 2 sections of the path
                    }
                }
            },
            pickers = {
                buffers = {
                    ignore_current_buffer = true,
                    sort_lastused = true,
                },
                find_files = {
                    theme = "dropdown",
                    previewer = false,
                },
                lsp_implementations = {
                    theme = "dropdown",
                }
            },
        }
    end,
}
