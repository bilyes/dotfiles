vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2

local jdtls = require('jdtls')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    require("jdtls.dap").setup_dap_main_class_configs()
    jdtls.setup_dap({ hotcodereplace = "auto" })

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

    vim.keymap.set("n", "<leader>dm", jdtls.test_nearest_method, bufopts)
end

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if root_dir == "" then
    --TODO print "No root directory found"
	return
end
local data_folder = vim.fn.stdpath("data")
local cache_folder = vim.fn.stdpath("cache")

-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This variable is used to configure eclipse to use the directory name of the
-- current project found using the root_marker as the folder for project specific data.
local workspace_folder = cache_folder .. "/nvim/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local bundles = {}
local mason_path = vim.fn.glob(data_folder .. "/mason/")
vim.list_extend(bundles, vim.split(vim.fn.glob(mason_path .. "packages/java-test/extension/server/*.jar"), "\n"))
vim.list_extend(
    bundles,
    vim.split(
        vim.fn.glob(mason_path .. "packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar"),
        "\n"
    )
)

local config = {
    cmd = {
        -- Make sure to set JAVA_HOME env environment to the appropriate java binary
        mason_path .. 'packages/jdtls/bin/jdtls',
        '-configuration', mason_path .. 'jdtls/config_linux',
        '-data', workspace_folder,
    },
    on_attach = on_attach,
    init_options = {
        bundles = bundles,
    }
}

jdtls.start_or_attach(config)
