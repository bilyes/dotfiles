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

  use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate'})

  use 'lewis6991/gitsigns.nvim'
  use 'vimwiki/vimwiki'

  use 'kyazdani42/nvim-tree.lua'
  --use 'folke/which-key.nvim'

  use 'mfussenegger/nvim-jdtls'

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
