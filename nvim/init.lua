require("basic")

-- Must be defined before loading plugins with lazy (or mappings in the fast path below)
vim.g.mapleader = " "

-- Fast path for tmux's todo capture popup: skip lazy.nvim and plugins,
-- keeping only basic options, mappings and :TodoCapture.
if vim.list_contains(vim.v.argv, "+TodoCapture here") then
    -- Use the terminal's palette and background instead of Neovim's default RGB colors.
    vim.opt.termguicolors = false
    require("mappings")
    if not vim.o.loadplugins then
        vim.cmd.runtime("plugin/todo-capture.lua")
    end
    return
end

-- Manage plugins using lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    spec = 'plugins',
    change_detection = { notify = false }
})

require("mappings")
