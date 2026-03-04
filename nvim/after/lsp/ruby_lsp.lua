-- Placed under after/lsp/ (not lsp/) so this config is merged AFTER nvim-lspconfig's
-- lsp/ruby_lsp.lua, overriding only `cmd` while inheriting filetypes, root_markers,
-- and reuse_client from lspconfig. See :h lsp-config-merge and :h after-directory.
return {
    cmd = function(dispatchers, config)
        return vim.lsp.rpc.start(
            { 'ruby-lsp' },
            dispatchers,
            {
                cwd = config.cmd_cwd or config.root_dir,
                env = { RUBY_LSP_BYPASS_TYPECHECKER = "1" },
            }
        )
    end,
}
