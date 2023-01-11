return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  
  use 'arcticicestudio/nord-vim'
  use 'tpope/vim-fugitive'
  use 'preservim/nerdcommenter'
  use 'vim-airline/vim-airline'

  -- use 'jremmen/vim-ripgrep'
  -- use 'lyuts/vim-rtags'

  -- use 'junegunn/fzf', { 'do': { -> fzf#install() } }
  -- use 'junegunn/fzf.vim'
  -- use 'mbbill/undotree'

  -- Auto pairs for '[', '{' and '('
  -- use 'jiangmiao/auto-pairs'

  -- Debugging
  -- use 'puremourning/vimspector'
  -- use 'szw/vim-maximizer'
  -- use 'vimwiki/vimwiki'
  
  -- Snippets
  -- use 'SirVer/ultisnips'
  -- use 'honza/vim-snippets'
  
  use 'neovim/nvim-lspconfig'
  use 'williamboman/mason.nvim'
  use 'williamboman/mason-lspconfig.nvim'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  
  -- use 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

end)
