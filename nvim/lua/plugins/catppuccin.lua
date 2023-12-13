return {
    'catppuccin/nvim',
    config = function()
        require("catppuccin").setup({
            flavour = "macchiato", -- latte, frappe, macchiato, mocha
            transparent_background = true,
        })

        vim.cmd.colorscheme('catppuccin')
    end
}
