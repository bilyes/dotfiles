-- Only needed when managing plugins with packer
-- Must be required in init.lua
return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'arcticicestudio/nord-vim'
    use 'tpope/vim-fugitive'
    use 'preservim/nerdcommenter'
    use 'nvim-lualine/lualine.nvim'
    use('junegunn/fzf', { run = "fzf#install()" })
    use 'junegunn/fzf.vim'
    -- Auto pairs for '[', '{' and '('
    use 'jiangmiao/auto-pairs'

    use 'neovim/nvim-lspconfig'
    use 'williamboman/mason.nvim'
    use 'williamboman/mason-lspconfig.nvim'
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'

    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })

    use 'lewis6991/gitsigns.nvim'
    use 'vimwiki/vimwiki'

    use 'kyazdani42/nvim-tree.lua'
    --use 'folke/which-key.nvim'

    use 'mfussenegger/nvim-jdtls'

    use({
        'folke/noice.nvim',
        requires = {
            'MunifTanjim/nui.nvim',
            -- OPTIONAL:
            --   `nvim-notify` is only needed, if you want to use the notification view.
            --   If not available, we use `mini` as the fallback
            'rcarriga/nvim-notify',
        }
    })

    use 'akinsho/toggleterm.nvim'

    use 'github/copilot.vim'

    use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }

    --use 'jackMort/ChatGPT.nvim'

    -- use 'jremmen/vim-ripgrep'
    -- use 'lyuts/vim-rtags'

    -- use 'mbbill/undotree'

    -- Debugging
    -- use 'puremourning/vimspector'
    -- use 'szw/vim-maximizer'

    -- Snippets
    -- use 'SirVer/ultisnips'
    -- use 'honza/vim-snippets'
end)
