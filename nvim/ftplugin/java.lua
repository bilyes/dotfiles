-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  --vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
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

local home = vim.loop.os_homedir()
local XDG_CACHE_HOME = os.getenv 'XDG_CACHE_HOME' or home .. '/.cache'
local XDG_DATA_HOME = os.getenv 'XDG_DATA_HOME' or home .. '/.local/share'

-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This variable is used to configure eclipse to use the directory name of the
-- current project found using the root_marker as the folder for project specific data.
local workspace_folder = XDG_CACHE_HOME .. "/nvim/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local config = {
    cmd = {
        -- Make sure to set JAVA_HOME env environment to the appropriate java binary
        XDG_DATA_HOME .. '/nvim/mason/packages/jdtls/bin/jdtls',
        '-configuration', XDG_DATA_HOME .. '/nvim/mason/jdtls/config_linux',
        '-data', workspace_folder,
    },
    on_attach = on_attach,
}

require('jdtls').start_or_attach(config)
