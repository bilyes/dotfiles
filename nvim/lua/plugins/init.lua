return {
    -- Auto pairs for '[', '{' and '('
    --'jiangmiao/auto-pairs',

    'neovim/nvim-lspconfig',
    -- Loaded eagerly so plugin/after/lsp.lua can call
    -- require('cmp_nvim_lsp').default_capabilities() at startup,
    -- before nvim-cmp itself is lazy-loaded on InsertEnter/LspAttach.
    'hrsh7th/cmp-nvim-lsp',

    --'folke/which-key.nvim',

    'mfussenegger/nvim-jdtls',

    'nvim-tree/nvim-web-devicons',

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
