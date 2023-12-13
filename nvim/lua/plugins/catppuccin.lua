return {
    'catppuccin/nvim',
    config = function()
        vim.cmd.colorscheme('catppuccin-macchiato')
        --vim.cmd.colorscheme('catppuccin')
        --vim.cmd.colorscheme('catppuccin-frappe')

        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
    end
}
