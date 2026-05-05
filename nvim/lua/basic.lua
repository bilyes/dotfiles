vim.opt.nu = true
vim.opt.rnu = true

--vim.g.netrw_browse_split = 4 -- Open in previous window
--vim.g.netrw_banner = 0
--vim.g.netrw_liststyle = 3 -- hierarchical style
--vim.g.netrw_winsize = 25

vim.opt.wrap = false

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.o.winborder = 'rounded'

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"

vim.opt.colorcolumn = "100"

vim.opt.swapfile = false
vim.opt.backup = false

local undodir = vim.fn.stdpath("data") .. "/undodir"
vim.fn.mkdir(undodir, "p")
vim.opt.undodir = undodir
vim.opt.undofile = true

vim.opt.updatetime = 250

--set foldmethod=syntax
--set foldnestmax=1

--"Needed for vimwiki
--set nocompatible
--filetype plugin on
