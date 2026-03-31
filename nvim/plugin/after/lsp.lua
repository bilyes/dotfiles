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
--vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    --trigger_workspace_diagnostics(client, bufnr)

    -- Enable completion triggered by <c-x><c-o>
    --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    --vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    local ok, telescope = pcall(require, 'telescope.builtin')
    local go_to_definition = ok and telescope.lsp_definitions or vim.lsp.buf.definition
    vim.keymap.set('n', '<leader>gd', go_to_definition, vim.tbl_extend('force', bufopts, { desc = 'Go to definition' }))
    vim.keymap.set('n', 'K', function() vim.lsp.buf.hover({ border = 'rounded' }) end,
        vim.tbl_extend('force', bufopts, { desc = 'Hover documentation' }))
    --vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    --vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    --vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    --vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    --vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', bufopts, { desc = 'Rename symbol' }))
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', bufopts, { desc = 'Code action' }))
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end,
        vim.tbl_extend('force', bufopts, { desc = 'Format buffer' }))
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Initialize lspconfig to add its configurations to the runtime path
--require('lspconfig')

vim.lsp.config('*', {
    on_attach = on_attach,
    capabilities = capabilities,
})

local servers = {
    --'denols',
    --'tsserver',
    'lua_ls',
    'gopls',
    --'terraformls',
    --'ltex',
    'pylsp',
    'ruby_lsp',
    'sorbet',
}
vim.lsp.enable(servers)
