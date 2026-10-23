-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
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
}
-- These start through a `cmd` function, which skips vim.lsp.enable's check that the
-- server is installed, so enable them only where it is.
for server, executable in pairs({ ruby_lsp = 'ruby-lsp', sorbet = 'srb' }) do
    if vim.fn.executable(executable) == 1 then
        table.insert(servers, server)
    end
end
vim.lsp.enable(servers)
