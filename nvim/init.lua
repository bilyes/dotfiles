require("basic")

-- Manage plugins using packer
--require("plugins_packer")

-- Manage plugins using lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Must be defined before loading plugins with lazy
vim.g.mapleader = " "

require('lazy').setup('plugins')

require("mappings")
