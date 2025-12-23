vim.g.mapleader = " "

local opts = { noremap = true, silent = true }

local function map(mode, lhs, rhs, options)
    vim.keymap.set(mode, lhs, rhs, options or opts)
end

local mappings = {
    {
        mode = 'i',
        mappings = {
            { 'jj',    '<Esc>' },
            { '<C-v>', '<Esc>"+pa' },
        }
    },
    {
        mode = 'n',
        mappings = {
            -- Window navigation
            { '<leader>h',  ':wincmd h<CR>' },
            { '<leader>j',  ':wincmd j<CR>' },
            { '<leader>k',  ':wincmd k<CR>' },
            { '<leader>l',  ':wincmd l<CR>' },

            -- File and directory operations
            { '<leader>pa', ':set paste! <CR>' },
            { '<leader>cd', ':cd %:p:h<CR> :pwd <CR>' },
            { '<leader>du', ':sav %:p:h/' },

            -- Text editing and manipulation
            { 'oo',         'o<Esc>k' },
            { 'OO',         'O<Esc>j' },
            { 'Y',          'y$' },
            { '<leader>sr', ':%s/\\<<C-r><C-w>\\>//gI<Left><Left><Left>' },

            -- Clipboard and system integration
            { 'cY',         '"+Y' },
            { 'cp',         '"+p' },
        }
    },
    {
        mode = 'v',
        mappings = {
            { 'J',  ":m '>+1<CR>gv=gv" },
            { 'K',  ":m '<-2<CR>gv=gv" },

            -- Clipboard and system integration
            { 'cy', '"+y' },
        }
    },
    {
        mode = 'x',
        mappings = {
            { '<leader>p', '"_dP' },
        }
    },
}

for _, section in ipairs(mappings) do
    for _, mapping in ipairs(section.mappings) do
        map(section.mode, mapping[1], mapping[2])
    end
end
