return {
    'neovim/nvim-lspconfig',
    -- Loaded eagerly so plugin/lsp.lua can call
    -- require('cmp_nvim_lsp').default_capabilities() at startup,
    -- before nvim-cmp itself is lazy-loaded on InsertEnter/LspAttach.
    'hrsh7th/cmp-nvim-lsp',

    { 'mfussenegger/nvim-jdtls', ft = 'java' },

    'nvim-tree/nvim-web-devicons',

    {
        "j-hui/fidget.nvim",
        event = 'LspAttach',
        opts = {
            notification = {
                window = {
                    winblend = 0,
                }
            }
        }
    }
}
