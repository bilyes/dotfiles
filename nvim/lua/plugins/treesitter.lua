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
                if lang and pcall(vim.treesitter.language.add, lang) then
                    pcall(vim.treesitter.start, ev.buf, lang)
                end
            end,
        })
    end,
}
