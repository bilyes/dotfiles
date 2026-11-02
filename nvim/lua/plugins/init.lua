return {
    'neovim/nvim-lspconfig',
    -- Loaded eagerly so plugin/lsp.lua can call
    -- require('cmp_nvim_lsp').default_capabilities() at startup,
    -- before nvim-cmp itself is lazy-loaded on InsertEnter/LspAttach.
    'hrsh7th/cmp-nvim-lsp',

    -- ftplugin/java.lua requires it, which also loads it
    { 'mfussenegger/nvim-jdtls', ft = 'java' },

    'nvim-tree/nvim-web-devicons',

    {
        "j-hui/fidget.nvim",
        -- Shows LSP progress, so it's needed once a server attaches. lsp/sorbet.lua requires
        -- fidget.progress, which loads it too.
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
