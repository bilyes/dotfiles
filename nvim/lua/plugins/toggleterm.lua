return {
    'akinsho/toggleterm.nvim',
    opts = {
        open_mapping = [[<c-x>]],
        direction = 'float',
        float_opts = {
            border = 'curved'
        },
        -- when neovim changes it current directory the terminal will change it's own when next it's opened
        autochdir = true,
    }
}
