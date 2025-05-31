return {
    'vimwiki/vimwiki',
    init = function()
        -- using init because vimwiki needs to know the vimwiki_list before
        -- loading, to know where to find all wikis. init() loads always and
        -- config() just loads when the plugin loads.
        vim.g.vimwiki_list = {
            { path = '~/wikis/main', syntax = 'markdown', ext = '.md' },
        }
        local opts = { noremap = true, silent = true }
        vim.keymap.set('n', '<leader>x', '<Plug>VimwikiToggleListItem h', opts)
    end,
    enabled = false,
}
