return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    lazy = false,
    config = function()
        require 'nvim-treesitter'.setup {
            -- A list of parser names, or "all" (the four listed parsers should always be installed)
            ensure_installed = {
                "ruby",
                "typescript",
                "go",
                "gomod",
                "gosum",
                "java",
                "yaml",
                "lua",
                "vim",
                --"help",
                "terraform",
                "javascript",
                "python",
                "graphql"
            },

            highlight = {
                enable = true,
            },

            indent = {
                enable = true,
            },
        }
    end
}
