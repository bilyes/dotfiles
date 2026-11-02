return {
    "mikavilpas/yazi.nvim",
    version = "^v14.0.0", -- needs yazi 26.8.15+
    cmd = "Yazi",
    dependencies = {
        { "nvim-lua/plenary.nvim", lazy = true },
    },
    keys = {
        {
            "<leader>pv",
            mode = { "n", "x" },
            "<cmd>Yazi<cr>",
            desc = "Open yazi at the current file",
        },
        {
            -- Open in the current working directory
            "<leader>cw",
            "<cmd>Yazi cwd<cr>",
            desc = "Open the file manager in nvim's working directory",
        },
    },
    opts = {
        -- Directories open in netrw. Setting this to true opens them in yazi instead,
        -- which requires loading yazi at startup and disabling netrw.
        open_for_directories = false,
        keymaps = {
            show_help = "<f1>",
        },
    },
}
