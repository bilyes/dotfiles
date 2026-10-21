-- Machine-specific Mason settings (e.g. install_root_dir) go in the git-ignored
-- plugins/local.lua.
return {
    {
        'mason-org/mason.nvim',
        config = true
    },
    {
        'mason-org/mason-lspconfig.nvim',
        dependencies = { 'mason-org/mason.nvim' },
        opts = {
            -- ftplugin/java.lua starts jdtls through nvim-jdtls; auto-enabling it
            -- here too would attach a second client.
            automatic_enable = { exclude = { 'jdtls' } },
        },
    },
}
