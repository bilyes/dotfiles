return {
    'preservim/nerdcommenter',
    -- Auto pairs for '[', '{' and '('
    --'jiangmiao/auto-pairs',

    'neovim/nvim-lspconfig',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',

    --'folke/which-key.nvim',

    'mfussenegger/nvim-jdtls',

    { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
    {
        "j-hui/fidget.nvim",
        opts = {
            notification = {
                window = {
                    winblend = 0,
                }
            }
        }
    }

    --'jackMort/ChatGPT.nvim',

    -- 'jremmen/vim-ripgrep',
    -- 'lyuts/vim-rtags',

    -- 'mbbill/undotree',

    -- Debugging
    -- 'puremourning/vimspector',
    -- 'szw/vim-maximizer',

    -- Snippets
    -- 'SirVer/ultisnips',
    -- 'honza/vim-snippets',
}
