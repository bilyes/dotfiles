vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2

local jdtls = require('jdtls')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
    local bufopts = { noremap = true, silent = true, buf = bufnr }
    vim.keymap.set("n", "<leader>dm", jdtls.test_nearest_method, bufopts)
end

-- A top-level build (Maven or Gradle wrapper, Gradle settings, repository root) wins over
-- the nearest module's pom.xml or build.gradle.
local root_dir = vim.fs.root(0, {
    { "mvnw", "gradlew", "settings.gradle", ".git" },
    { "pom.xml", "build.gradle" },
})
if not root_dir then
    return
end

-- mason.nvim sets $MASON to its install root (its default, or install_root_dir from
-- plugins/local.lua).
local mason = vim.env.MASON
local jdtls_dir = mason and mason .. "/packages/jdtls"
if not jdtls_dir or vim.fn.executable(jdtls_dir .. "/bin/jdtls") == 0 then
    vim.notify_once("jdtls isn't installed in the current Mason root; run :MasonInstall jdtls", vim.log.levels.WARN)
    return
end

-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This uses the project folder's name plus a hash of its path, so projects with the
-- same folder name don't share one.
local workspace_folder = vim.fn.stdpath("cache") .. "/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
    .. "-" .. vim.fn.sha256(root_dir):sub(1, 8)

-- java-test's folder also holds a test runner and a coverage agent, which aren't jdtls
-- plugins; nvim-jdtls's README leaves them out.
local bundles = {}
for _, jar in ipairs(vim.fn.glob(mason .. "/packages/java-test/extension/server/*.jar", false, true)) do
    local name = vim.fn.fnamemodify(jar, ":t")
    if name ~= "com.microsoft.java.test.runner-jar-with-dependencies.jar" and name ~= "jacocoagent.jar" then
        table.insert(bundles, jar)
    end
end
vim.list_extend(
    bundles,
    vim.fn.glob(mason .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", false, true)
)

-- nvim-jdtls sets up the debug adapter itself when jdtls attaches, with default options,
-- and ignores later setups, so set it up before starting jdtls. Main classes are discovered
-- when you start debugging.
jdtls.setup_dap({
    config_overrides = {
        vmArgs = "--enable-preview" -- needed for spring boot
    },
    hotcodereplace = "auto"
})
require("dap").configurations.java = {
    {
        name = "Debug (Attach)",
        type = "java",
        request = "attach",
        hostName = "localhost",
        port = 5005,
    },
}

local config = {
    cmd = {
        -- Make sure to set JAVA_HOME env environment to the appropriate java binary.
        -- The bin/jdtls launcher picks the platform's configuration directory itself.
        jdtls_dir .. '/bin/jdtls',
        '--jvm-arg=-javaagent:' .. jdtls_dir .. '/lombok.jar',
        '-data', workspace_folder,
    },
    root_dir = root_dir,
    -- nvim-jdtls starts jdtls itself, so the vim.lsp.config('*') capabilities from
    -- plugin/lsp.lua don't reach it.
    capabilities = require('cmp_nvim_lsp').default_capabilities(),
    on_attach = on_attach,
    init_options = {
        bundles = bundles,
    }
}

jdtls.start_or_attach(config)
