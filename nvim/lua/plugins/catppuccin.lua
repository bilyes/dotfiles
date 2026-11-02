return {
    'catppuccin/nvim',
    -- Without a name, lazy.nvim would name it after the repo: "nvim"
    name = 'catppuccin',
    lazy = false,
    -- Load before the other startup plugins, so they set up with its colors
    priority = 1000,
    config = function()
        -- latte, frappe, macchiato, mocha
        vim.cmd.colorscheme('catppuccin-macchiato')
        -- Make float windows (e.g. LSP hover) more visible
        vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#8aadf4" })
    end
}
