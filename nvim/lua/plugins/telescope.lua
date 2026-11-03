-- Functions, so Telescope is only required, and loaded, on the first key press
local function picker(name)
    return function() require('telescope.builtin')[name]() end
end
local function live_grep_args()
    require('telescope').extensions.live_grep_args.live_grep_args()
end

return {
    'nvim-telescope/telescope.nvim',
    version = '*',
    cmd = 'Telescope',
    keys = {
        { "<tab>p",     picker('find_files'),           desc = 'Find files' },
        { "<leader>fc", picker('commands'),             desc = 'Find commands' },
        { "<leader>fs", live_grep_args,                 desc = 'Live grep' },
        { "<leader>fb", picker('buffers'),              desc = 'Find buffers' },
        { "<leader>fh", picker('help_tags'),            desc = 'Find help tags' },
        { "<leader>fr", picker('lsp_references'),       desc = 'Find LSP references' },
        { "<leader>fi", picker('lsp_implementations'),  desc = 'Find LSP implementations' },
        { "<leader>ds", picker('lsp_document_symbols'), desc = 'Find document symbols' },
        -- TODO use live_grep_args for this?
        { "<leader>fw", picker('grep_string'),          desc = 'Grep word under cursor' },
    },
    init = function()
        -- The first vim.ui.select call loads Telescope, whose ui-select extension replaces it.
        -- Restoring the original first means a failed load can't recurse.
        local select = vim.ui.select
        vim.ui.select = function(...)
            vim.ui.select = select
            require('lazy').load({ plugins = { 'telescope.nvim' } })
            return vim.ui.select(...)
        end
    end,
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
        {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make',
        },
    },
    config = function()
        local builtin = require('telescope.builtin')
        local telescope = require('telescope')
        local lga_actions = require("telescope-live-grep-args.actions")
        local action_state = require("telescope.actions.state")

        local function find_files_no_ignore()
            local line = action_state.get_current_line()
            builtin.find_files({ no_ignore = true, default_text = line })
        end

        local function find_files_with_hidden()
            local line = action_state.get_current_line()
            builtin.find_files({ hidden = true, default_text = line })
        end

        telescope.setup {
            defaults = {
                layout_strategy = 'vertical',
                preview = {
                    treesitter = true,
                },
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
                    -- A function, so each search starts from a fresh list: find_files appends
                    -- flags like --hidden to the list it's given, and they'd stick for the session.
                    find_command = function()
                        return {
                            "fd", "--type", "f",
                            "--exclude", ".git",
                            "--exclude", "node_modules",
                            "--exclude", "build",
                            "--exclude", "dist",
                            "--exclude", "yarn.lock",
                            "--exclude", ".npm",
                            -- images
                            "--exclude", "*.png",
                            "--exclude", "*.jpg",
                            "--exclude", "*.jpeg",
                            "--exclude", "*.gif",
                            "--exclude", "*.webp",
                            "--exclude", "*.svg",
                            "--exclude", "*.bmp",
                            "--exclude", "*.ico",
                            "--exclude", "*.tiff",
                            "--exclude", "*.tif",
                            "--exclude", "*.heic",
                            "--exclude", "*.heif",
                            "--exclude", "*.avif",
                            -- videos
                            "--exclude", "*.mp4",
                            "--exclude", "*.mov",
                            "--exclude", "*.avi",
                            "--exclude", "*.mkv",
                            "--exclude", "*.webm",
                            "--exclude", "*.flv",
                            "--exclude", "*.wmv",
                            "--exclude", "*.m4v",
                            "--exclude", "*.mpg",
                            "--exclude", "*.mpeg",
                            "--exclude", "*.3gp",
                        }
                    end,
                    theme = "dropdown",
                    previewer = false,
                    mappings = {
                        i = {
                            ["<a-i>"] = find_files_no_ignore,
                            ["<a-h>"] = find_files_with_hidden,
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
                    mappings = {         -- extend mappings
                        i = {
                            -- Not <C-i>: terminals send it as Tab, which would replace Tab's
                            -- multi-select in this picker
                            ["<C-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
                            ["<C-t>"] = lga_actions.quote_prompt({ postfix = " --type " }),
                            -- freeze the current list and start a fuzzy search in the frozen list
                            ["<C-space>"] = require("telescope.actions").to_fuzzy_refine,
                        },
                    },
                }
            }
        }

        telescope.load_extension('ui-select')
        telescope.load_extension("live_grep_args")
        telescope.load_extension('fzf')
    end,
}
