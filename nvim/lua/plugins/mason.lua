-- Machine-specific Mason settings (e.g. install_root_dir) go in the git-ignored
-- plugins/local.lua.
return {
    {
        'williamboman/mason.nvim',
        config = true
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = { 'williamboman/mason.nvim' },
        opts = {
            -- ftplugin/java.lua starts jdtls through nvim-jdtls; auto-enabling it
            -- here too would attach a second client.
            automatic_enable = { exclude = { 'jdtls' } },
        },
    },
}
