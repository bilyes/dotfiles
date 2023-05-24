return {
    'arcticicestudio/nord-vim',
    'tpope/vim-fugitive',
    'preservim/nerdcommenter',
    'nvim-lualine/lualine.nvim',
    { 'junegunn/fzf', build = "fzf#install()" },
    'junegunn/fzf.vim',
    -- Auto pairs for '[', '{' and '('
    'jiangmiao/auto-pairs',

    'neovim/nvim-lspconfig',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',

    { 'nvim-treesitter/nvim-treesitter', build = ':TSUpdate' },

    'lewis6991/gitsigns.nvim',
    'vimwiki/vimwiki',

    'kyazdani42/nvim-tree.lua',
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

    'akinsho/toggleterm.nvim',

    'github/copilot.vim',

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
