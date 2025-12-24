return {
    'nvim-telescope/telescope.nvim',
    tag = 'v0.2.0',
    dependencies = {
        {
            'nvim-lua/plenary.nvim',
        },
        {
            'nvim-telescope/telescope-ui-select.nvim'
        },
        {
            "nvim-telescope/telescope-live-grep-args.nvim",
            version = "^1.0.0",
        },
    },
    config = function()
        local builtin = require('telescope.builtin')
        local mappings = {
            { "<tab>p",     builtin.find_files },
            { "<leader>fc", builtin.commands },
            --{ "<leader>fs", builtin.live_grep },
            { "<leader>fs", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>" },
            { "<leader>fb", builtin.buffers },
            { "<leader>fh", builtin.help_tags },
            { "<leader>fr", builtin.lsp_references },
            { "<leader>fi", builtin.lsp_implementations },
            { "<leader>ds", builtin.lsp_document_symbols },
            -- TODO use live_grep_args for this?
            { "<leader>fw", builtin.grep_string },
        }
        for _, map in ipairs(mappings) do
            local key, func = map[1], map[2]
            vim.keymap.set('n', key, func, { noremap = true, silent = true })
        end

        local telescope = require('telescope')
        local lga_actions = require("telescope-live-grep-args.actions")

        telescope.setup {
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
                    sort_mru = true,
                },
                find_files = {
                    hidden = true,    -- show hidden files
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
            extensions = {
                live_grep_args = {
                    auto_quoting = true, -- enable/disable auto-quoting
                    -- define mappings, e.g.
                    mappings = {         -- extend mappings
                        i = {
                            --["<C-k>"] = lga_actions.quote_prompt(),
                            ["<C-i>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                            ["<C-t>"] = lga_actions.quote_prompt({ postfix = " --type " }),
                            -- freeze the current list and start a fuzzy search in the frozen list
                            ["<C-space>"] = lga_actions.to_fuzzy_refine,
                        },
                    },
                    -- ... also accepts theme settings, for example:
                    -- theme = "dropdown", -- use dropdown theme
                    -- theme = { }, -- use own theme spec
                    -- layout_config = { mirror=true }, -- mirror preview pane
                }
            }
        }

        telescope.load_extension('ui-select')
        telescope.load_extension("live_grep_args")
    end,
}
