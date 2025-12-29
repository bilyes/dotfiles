return {
    'catppuccin/nvim',
    lazy = false,
    config = function()
        -- latte, frappe, macchiato, mocha
        vim.cmd.colorscheme('catppuccin-macchiato')
    end
}
