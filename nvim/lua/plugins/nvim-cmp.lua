return {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'LspAttach' },
    dependencies = {
        'L3MON4D3/LuaSnip',
    },
    config = function()
        local cmp = require 'cmp'

        cmp.setup({
            snippet = {
                -- REQUIRED - you must specify a snippet engine
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            window = {
                documentation = cmp.config.window.bordered(),
            },
            mapping = cmp.mapping.preset.insert({
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                ['<tab>'] = cmp.mapping.select_next_item(),
                ['<S-tab>'] = cmp.mapping.select_prev_item(),
            }),
            sources = cmp.config.sources({
                -- Completes require() paths in Lua; group_index 0 skips LuaLS's own
                -- completions for them
                { name = 'lazydev', group_index = 0 },
                { name = 'nvim_lsp' },
            })
        })
    end,
}
