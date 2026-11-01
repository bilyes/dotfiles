-- `cp` pastes the system clipboard inline, except in Markdown buffers that
-- belong to a project with an `.img-clip.lua`: there, a clipboard image is
-- saved and linked at the cursor instead.
local function paste_clipboard()
    if vim.bo.filetype ~= 'markdown' then
        return false
    end
    local name = vim.api.nvim_buf_get_name(0)
    if name == '' then
        return false
    end
    local found = vim.fs.find('.img-clip.lua', { upward = true, path = vim.fs.dirname(name) })
    if #found == 0 then
        return false
    end
    local loaded, imgclip = pcall(require, 'img-clip')
    if not loaded then
        return false
    end
    if not require('img-clip.clipboard').content_is_image() then
        return false
    end
    local ok, project = pcall(dofile, found[1])
    if not ok or type(project) ~= 'table' then
        vim.notify('cp: could not load ' .. found[1], vim.log.levels.ERROR)
        return true
    end
    imgclip.paste_image(project)
    return true
end

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
            { 'cp',         function()
                if not paste_clipboard() then
                    vim.cmd(('normal! %d"+p'):format(vim.v.count1))
                end
            end, desc = 'Paste from system clipboard (images into project Markdown)' },
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
