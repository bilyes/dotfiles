require'nvim-treesitter.configs'.setup {
  -- A list of parser names, or "all" (the four listed parsers should always be installed)
  ensure_installed = { "ruby", "typescript", "go", "java", "yaml", "lua", "vim", "help", "terraform" },

  highlight = {
    enable = true,
  },
}
