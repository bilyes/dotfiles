local loaded_clients = {}

local function list_workspace_files()
    local workspace_files = vim.fn.split(vim.fn.system('git ls-files'), "\n")
    -- convert paths to absolute
    local full_path_files = {}
    for _, path in ipairs(workspace_files) do
        table.insert(full_path_files, vim.fn.fnamemodify(path, ":p"))
    end
    return full_path_files
end

local function trigger_workspace_diagnostics(client, bufnr)
    local workspace_files = list_workspace_files()
    if #workspace_files == 0 then
        return
    end
    if vim.tbl_contains(loaded_clients, client.id) then
        return
    end
    table.insert(loaded_clients, client.id)

    if not vim.tbl_get(client.server_capabilities, 'textDocumentSync', 'openClose') then
        return
    end

    for _, path in ipairs(workspace_files) do
        if path == vim.api.nvim_buf_get_name(bufnr) then
            goto continue
        end

        local filetype = vim.filetype.match({ filename = path })

        if not vim.tbl_contains(client.config.filetypes, filetype) then
            goto continue
        end

        local params = {
            textDocument = {
                uri = vim.uri_from_fname(path),
                version = 0,
                text = vim.fn.join(vim.fn.readfile(path), "\n"),
                languageId = filetype
            }
        }
        client.notify('textDocument/didOpen', params)

        ::continue::
    end
end

-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
--vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
--vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
--vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)

    trigger_workspace_diagnostics(client, bufnr)

    -- Enable completion triggered by <c-x><c-o>
    --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    --vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', '<leader>gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    --vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    --vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    --vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    --vim.keymap.set('n', '<leader>wl', function()
    --print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    --end, bufopts)
    --vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
end

-- Set up nvim-cmp.
local cmp = require 'cmp'

cmp.setup({
    snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
    --            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
     require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        --        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        --        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        --        ['<C-Space>'] = cmp.mapping.complete(),
        --        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        ['<tab>'] = cmp.mapping.select_next_item(),
        ['<S-tab>'] = cmp.mapping.select_prev_item(),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        -- { name = 'vsnip' }, -- For vsnip users.
        -- { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = 'buffer' },
    })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local servers = {
    'denols',
    --'tsserver',
    --'lua_ls',
    'gopls',
    'terraformls',
    --'ltex',
}

for _, lsp in ipairs(servers) do
    vim.lsp.config(lsp, {
        on_attach = on_attach,
        capabilities = capabilities,
    })
end

vim.lsp.config('lua_ls', {
    on_attach = on_attach,
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = {
                globals = {
                    'vim',
                },
            },
        }
    },
})
