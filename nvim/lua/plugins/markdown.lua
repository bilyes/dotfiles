return {
    "tadmccorkle/markdown.nvim",
    lazy = true,
    event = {
        -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
        "BufReadPre " .. vim.fn.expand "~" .. "/code/**.md",
        "BufNewFile " .. vim.fn.expand "~" .. "/code/**.md",
    },
    --ft = "markdown", -- or 'event = "VeryLazy"'
    opts = {
        -- configuration here or empty for defaults
    },
}
