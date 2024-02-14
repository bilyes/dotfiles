return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    --opts = {},
    config = function()
        local opts = { noremap = true, silent = true }
        local trouble = require("trouble")

        vim.keymap.set("n", "<leader>xx", function() trouble.toggle() end, opts)
        vim.keymap.set("n", "<leader>xw", function() trouble.toggle("workspace_diagnostics") end, opts)
        vim.keymap.set("n", "<leader>xd", function() trouble.toggle("document_diagnostics") end, opts)
        vim.keymap.set("n", "<leader>xq", function() trouble.toggle("quickfix") end, opts)
        vim.keymap.set("n", "<leader>xl", function() trouble.toggle("loclist") end, opts)
        --vim.keymap.set("n", "gR", function() trouble.toggle("lsp_references") end, opts)
    end
}
