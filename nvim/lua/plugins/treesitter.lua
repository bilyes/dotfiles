return {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    build = ':TSUpdate',
    lazy = false,
    config = function()
        require('nvim-treesitter').install({
            "ruby",
            "typescript",
            "go",
            "gomod",
            "gosum",
            "java",
            "yaml",
            "lua",
            "vim",
            "terraform",
            "javascript",
            "python",
            "graphql",
        })

        vim.api.nvim_create_autocmd('FileType', {
            callback = function(ev)
                local lang = vim.treesitter.language.get_lang(ev.match)
                -- language.add() returns nil (rather than erroring) when there's no parser
                if lang and vim.treesitter.language.add(lang) then
                    pcall(vim.treesitter.start, ev.buf, lang)
                end
            end,
        })
    end,
}
