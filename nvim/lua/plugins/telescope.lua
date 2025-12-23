return {
    'nvim-telescope/telescope.nvim',
    tag = 'v0.2.0',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
        local builtin = require('telescope.builtin')
        local mappings = {
            { "<tab>p", builtin.find_files },
            { "<leader>fc", builtin.commands },
            { "<leader>fs", builtin.live_grep },
            { "<leader>fb", builtin.buffers },
            { "<leader>fh", builtin.help_tags },
            { "<leader>fr", builtin.lsp_references },
            { "<leader>fi", builtin.lsp_implementations },
            { "<leader>ds", builtin.lsp_document_symbols },
            { "<leader>fw", builtin.grep_string },
        }
        for _, map in ipairs(mappings) do
            local key, func = map[1], map[2]
            vim.keymap.set('n', key, func, { noremap = true, silent = true })
        end

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
                    hidden = true, -- show hidden files
                    no_ignore = true, -- do not respect .gitignore
                    file_ignore_patterns = {
                        "^node_modules/",
                        "^build/",
                        "^dist/",
                        "^yarn%.lock",
                        "^%.git/",
                        "^%.np/",
                    },
                    theme = "dropdown",
                    previewer = false,
                    mappings = {
                        i = {
                            ["<C-h>"] = require('telescope.actions').file_split,
                        },
                    },
                },
                lsp_implementations = {
                    theme = "dropdown",
                }
            },
        }
    end,
}
