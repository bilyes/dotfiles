return {
    'vimwiki/vimwiki',
    config = function()
        --Needed for vimwiki
        --set nocompatible
        --filetype plugin on

        vim.g.vimwiki_list = {
            { path = '~/wikis/main', syntax = 'markdown', ext = '.md' },
        }
    end
}
