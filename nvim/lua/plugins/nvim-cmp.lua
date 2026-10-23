return {
    'hrsh7th/nvim-cmp',
    event = { 'InsertEnter', 'LspAttach' },
    config = function()
        local cmp = require 'cmp'

        -- No snippet engine: nvim-cmp expands snippets with Neovim's vim.snippet, and when the
        -- menu is closed, <tab>/<S-tab> below fall back to Neovim's placeholder jumps.
        cmp.setup({
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
