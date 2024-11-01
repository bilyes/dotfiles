return {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    config = function()
        require 'nvim-treesitter.configs'.setup {
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
                "graphql"
            },

            highlight = {
                enable = true,
            },
        }
    end
}
