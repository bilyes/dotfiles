return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    --ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
        -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
        "BufReadPre " .. vim.fn.expand "~" .. "/notes/**.md",
        "BufNewFile " .. vim.fn.expand "~" .. "/notes/**.md",
        --"BufReadPre path/to/my-vault/**.md",
        --"BufNewFile path/to/my-vault/**.md",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "notes",
                path = "~/notes",
            },
            --{
            --name = "work",
            --path = "~/vaults/work",
            --},
        },

        disable_frontmatter = true,
        note_id_func = function(title)
            return title
        end,

        daily_notes = {
            folder = "main/diary",
        },

        preferred_link_style = "markdown",

        new_notes_location = "notes_subdir",

        legacy_commands = false, -- remove this after version 4

        callbacks = {
            enter_note = function(_, note)
                vim.keymap.set("n", "<tab>p", "<cmd>Obsidian quick_switch<cr>", {
                    buffer = note.bufnr,
                    desc = "Quick switch",
                })
                vim.keymap.set("n", "<leader>fs", "<cmd>Obsidian search<cr>", {
                    buffer = note.bufnr,
                    desc = "Search notes",
                })
                vim.keymap.set("n", "<leader>ta", "<cmd>Obsidian tags<cr>", {
                    buffer = note.bufnr,
                    desc = "Show tags",
                })
                vim.keymap.set("n", "<leader>to", "<cmd>Obsidian today<cr>", {
                    buffer = note.bufnr,
                    desc =  "Open today's note",
                })
                vim.keymap.set("n", "<leader>gd", "<cmd>Obsidian follow_link<cr>", {
                    buffer = note.bufnr,
                    desc =  "Follow link under cursor",
                })
                vim.keymap.set("n", "<leader>ch", "<cmd>Obsidian toggle_checkbox<cr>", {
                    buffer = note.bufnr,
                    desc =  "Toggle checkbox",
                })
            end,
        },
    },
}
