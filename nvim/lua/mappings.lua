local mappings = {
    {
        mode = 'i',
        mappings = {
            { 'jj',    '<Esc>',      desc = 'Exit insert mode' },
            { '<C-v>', '<Esc>"+pa',  desc = 'Paste from system clipboard' },
        }
    },
    {
        mode = 'n',
        mappings = {
            -- Window navigation
            { '<leader>h',  ':wincmd h<CR>', desc = 'Move to left window' },
            { '<leader>j',  ':wincmd j<CR>', desc = 'Move to bottom window' },
            { '<leader>k',  ':wincmd k<CR>', desc = 'Move to top window' },
            { '<leader>l',  ':wincmd l<CR>', desc = 'Move to right window' },

            -- File and directory operations
            { '<leader>pa', ':set paste! <CR>',  desc = 'Toggle paste mode' },
            { '<leader>cd', ':cd %:p:h<CR> :pwd <CR>', desc = 'cd to current file directory' },
            { '<leader>du', ':sav %:p:h/',       desc = 'Duplicate file' },

            -- Text editing and manipulation
            { 'oo',         'o<Esc>k',           desc = 'Add blank line below' },
            { 'OO',         'O<Esc>j',           desc = 'Add blank line above' },
            { '<leader>sr', ':%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>', desc = 'Search and replace word under cursor' },

            -- Clipboard and system integration
            { 'cY',         '"+Y',  desc = 'Yank line to system clipboard' },
            { 'cp',         '"+p',  desc = 'Paste from system clipboard' },
        }
    },
    {
        mode = 'v',
        mappings = {
            { 'J',  ":m '>+1<CR>gv=gv", desc = 'Move selection down' },
            { 'K',  ":m '<-2<CR>gv=gv", desc = 'Move selection up' },

            -- Clipboard and system integration
            { 'cy', '"+y', desc = 'Yank selection to system clipboard' },
        }
    },
    {
        mode = 'x',
        mappings = {
            { '<leader>p', '"_dP', desc = 'Paste without overwriting register' },
        }
    },
}

for _, section in ipairs(mappings) do
    for _, mapping in ipairs(section.mappings) do
        vim.keymap.set(section.mode, mapping[1], mapping[2], { noremap = true, silent = true, desc = mapping.desc })
    end
end
