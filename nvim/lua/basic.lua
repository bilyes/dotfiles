vim.opt.nu = true
vim.opt.rnu = true

vim.g.netrw_browse_split = 4 -- Open in previous window
vim.g.netrw_banner = 0
vim.g.netrw_liststyle = 3 -- hierarchical style
vim.g.netrw_winsize = 25

--" don't require buffers to be saved before navigating away from them
vim.opt.hidden = true

vim.opt.wrap = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.colorcolumn = "100"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

--set foldmethod=syntax
--set foldnestmax=1

--"Needed for vimwiki
--set nocompatible
--filetype plugin on
