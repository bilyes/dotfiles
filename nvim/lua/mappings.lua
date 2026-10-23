local mappings = {
    {
        mode = 'i',
        mappings = {
            { 'jj',    '<Esc>',      desc = 'Exit insert mode' },
            { '<C-v>', '<C-r><C-o>+', desc = 'Paste from system clipboard' },
        }
    },
    {
        mode = 'n',
        mappings = {
            -- Window navigation
            { '<leader>h',  function() vim.cmd.wincmd('h') end, desc = 'Move to left window' },
            { '<leader>j',  function() vim.cmd.wincmd('j') end, desc = 'Move to bottom window' },
            { '<leader>k',  function() vim.cmd.wincmd('k') end, desc = 'Move to top window' },
            { '<leader>l',  function() vim.cmd.wincmd('l') end, desc = 'Move to right window' },

            -- File and directory operations
            { '<leader>cd', ':cd %:p:h<CR>:pwd<CR>', desc = 'cd to current file directory' },
            { '<leader>du', ':sav %:p:h/',       desc = 'Duplicate file', silent = false },

            -- Text editing and manipulation
            { 'oo',         'o<Esc>k',           desc = 'Add blank line below' },
            { 'OO',         'O<Esc>j',           desc = 'Add blank line above' },
            { '<leader>sr', ':%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>', desc = 'Search and replace word under cursor', silent = false },

            -- Clipboard and system integration
            { 'cY',         '"+Y',  desc = 'Yank line to system clipboard' },
            { 'cp',         '"+p',  desc = 'Paste from system clipboard' },
        }
    },
    {
        -- Visual mode only ('v' would also cover Select mode, where these
        -- letters must type text, e.g. into snippet placeholders)
        mode = 'x',
        mappings = {
            { 'J',  ":m '>+1<CR>gv=gv", desc = 'Move selection down' },
            { 'K',  ":m '<-2<CR>gv=gv", desc = 'Move selection up' },
            { '<leader>p', '"_dP', desc = 'Paste without overwriting register' },

            -- Clipboard and system integration
            { 'cy', '"+y', desc = 'Yank selection to system clipboard' },
        }
    },
}

-- Mappings that leave a command half-typed set `silent = false`: silent would keep
-- the command line blank until the first key is typed.
for _, section in ipairs(mappings) do
    for _, mapping in ipairs(section.mappings) do
        vim.keymap.set(section.mode, mapping[1], mapping[2],
            { noremap = true, silent = mapping.silent ~= false, desc = mapping.desc })
    end
end
