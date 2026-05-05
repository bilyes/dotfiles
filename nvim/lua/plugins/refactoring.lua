return {
    "ThePrimeagen/refactoring.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        'nvim-telescope/telescope.nvim',
    },
    keys = {
        {
            "<leader>re",
            function()
                require("telescope").load_extension("refactoring")
                require('telescope').extensions.refactoring.refactors()
            end,
            mode = { "n", "x" },
            desc = "Refactors",
        },
    },
    opts = {},
}
