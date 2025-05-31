return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = "markdown",
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

        mappings = {
            ["<tab>p"] = {
                action = function()
                    vim.cmd("ObsidianQuickSwitch")
                end,
                description = "Quick switch",
            },
            ["<leader>fs"] = {
                action = function()
                    vim.cmd("ObsidianSearch")
                end,
                description = "Search notes",
            },
            ["<leader>ta"] = {
                action = function()
                    vim.cmd("ObsidianTags")
                end,
                description = "Show tags",
            },
            ["<leader>to"] = {
                action = function()
                    vim.cmd("ObsidianToday")
                end,
                description = "Open today's note",
            },
        },
    },
}
