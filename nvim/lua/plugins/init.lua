return {
    'preservim/nerdcommenter',
    -- Auto pairs for '[', '{' and '('
    'jiangmiao/auto-pairs',

    'neovim/nvim-lspconfig',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',

    --'folke/which-key.nvim',

    'mfussenegger/nvim-jdtls',

    {
        'folke/noice.nvim',
        dependencies = {
            'MunifTanjim/nui.nvim',
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            'rcarriga/nvim-notify',
        }
    },

    { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap"} },

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
