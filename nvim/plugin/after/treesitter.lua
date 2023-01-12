require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = { "ruby", "typescript", "go", "lua", "vim", "help" },

  highlight = {
    enable = true,
  },
}
