return {
    "tadmccorkle/markdown.nvim",
    event = {
        "BufReadPre " .. vim.fn.expand "~" .. "/code/**.md",
        "BufNewFile " .. vim.fn.expand "~" .. "/code/**.md",
    },
    opts = {
        mappings = {
            go_curr_heading = false, -- keep ]c for gitsigns' next hunk
        },
    },
}
