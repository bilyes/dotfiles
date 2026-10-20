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

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    --trigger_workspace_diagnostics(client, bufnr)

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buf = bufnr }
    local go_to_definition = function()
        local ok, telescope = pcall(require, 'telescope.builtin')
        if ok then telescope.lsp_definitions() else vim.lsp.buf.definition() end
    end
    vim.keymap.set('n', '<leader>gd', go_to_definition, vim.tbl_extend('force', bufopts, { desc = 'Go to definition' }))
    vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, vim.tbl_extend('force', bufopts, { desc = 'Show diagnostics' }))
    -- Rename: use built-in `grn`
    -- Code action: use built-in `gra`
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end,
        vim.tbl_extend('force', bufopts, { desc = 'Format buffer' }))
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

vim.lsp.config('*', {
    capabilities = capabilities,
})

-- Run on_attach from an LspAttach autocmd rather than `vim.lsp.config('*')`: a server config
-- that defines its own `on_attach` (several nvim-lspconfig ones do) would replace it.
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('user.lsp', {}),
    callback = function(ev)
        on_attach(vim.lsp.get_client_by_id(ev.data.client_id), ev.buf)
    end,
})

local servers = {
    'lua_ls',
    'gopls',
    'pylsp',
    'ruby_lsp',
    'sorbet',
}
vim.lsp.enable(servers)
