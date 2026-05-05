-- Placed under after/lsp/ to override nvim-lspconfig's default cmd while inheriting
-- filetypes and root_markers. See :h lsp-config-merge and :h after-directory.
--
-- Adds --cache-dir so Sorbet persists its work between sessions. The cache is
-- project-specific (hashed from root_dir) to avoid collisions across codebases.
return {
    cmd = function(dispatchers, config)
        local root = config.root_dir or vim.fn.getcwd()
        local cache_key = vim.fn.sha256(root):sub(1, 8)
        local cache_dir = vim.fn.stdpath("cache") .. "/sorbet/" .. cache_key
        return vim.lsp.rpc.start(
            { 'srb', 'tc', '--lsp', '--cache-dir', cache_dir },
            dispatchers,
            { cwd = root }
        )
    end,
}
