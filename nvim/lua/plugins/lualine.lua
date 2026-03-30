return {
    'nvim-lualine/lualine.nvim',
    opts = {
        sections = {
            lualine_a = {
                {
                    'mode',
                    fmt = function(name)
                        local map = {
                            ['NORMAL']   = 'N',
                            ['INSERT']   = 'I',
                            ['VISUAL']   = 'V',
                            ['V-LINE']   = 'L',
                            ['V-BLOCK']  = 'B',
                            ['COMMAND']  = 'C',
                            ['REPLACE']  = 'R',
                            ['TERMINAL'] = 'T',
                            ['SELECT']   = 'S',
                            ['S-LINE']   = 'S',
                            ['S-BLOCK']  = 'S',
                        }
                        return map[name] or name:sub(1, 1)
                    end,
                },
            },
            lualine_b = {
                {
                    'branch',
                    fmt = function(name)
                        local max = 30
                        if #name > max then
                            return name:sub(1, max) .. '…'
                        end
                        return name
                    end,
                },
                'diff',
                'diagnostics',
            },
            lualine_c = { { 'filename', path = 1 } },
            lualine_x = { { 'filetype', icon_only = true } },
        },
    },
}
