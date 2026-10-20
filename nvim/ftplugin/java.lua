vim.opt_local.tabstop = 2
vim.opt_local.softtabstop = 2
vim.opt_local.shiftwidth = 2

local jdtls = require('jdtls')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
    require("jdtls.dap").setup_dap_main_class_configs()

    require("dap").configurations.java = {
        {
            name = "Debug (Attach)",
            type = "java",
            request = "attach",
            hostName = "localhost",
            port = 5005,
        },
    }

    jdtls.setup_dap({
        config_overrides = {
            vmArgs = "--enable-preview" -- needed for spring boot
        },
        hotcodereplace = "auto"
    })

    local bufopts = { noremap = true, silent = true, buf = bufnr }
    vim.keymap.set("n", "<leader>dm", jdtls.test_nearest_method, bufopts)
end

local root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
local root_dir = require("jdtls.setup").find_root(root_markers)
if not root_dir then
    return
end

-- mason.nvim sets $MASON to its install root (configured in lua/plugins/mason.lua).
local mason = vim.env.MASON
local jdtls_dir = mason and mason .. "/packages/jdtls"
if not jdtls_dir or vim.fn.executable(jdtls_dir .. "/bin/jdtls") == 0 then
    vim.notify_once("jdtls isn't installed in the current Mason root; run :MasonInstall jdtls", vim.log.levels.WARN)
    return
end

-- eclipse.jdt.ls stores project specific data within a folder. If you are working
-- with multiple different projects, each project must use a dedicated data directory.
-- This variable is used to configure eclipse to use the directory name of the
-- current project found using the root_marker as the folder for project specific data.
local workspace_folder = vim.fn.stdpath("cache") .. "/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

local bundles = vim.fn.glob(mason .. "/packages/java-test/extension/server/*.jar", false, true)
vim.list_extend(
    bundles,
    vim.fn.glob(mason .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", false, true)
)

local config = {
    cmd = {
        -- Make sure to set JAVA_HOME env environment to the appropriate java binary.
        -- The bin/jdtls launcher picks the platform's configuration directory itself.
        jdtls_dir .. '/bin/jdtls',
        '--jvm-arg=-javaagent:' .. jdtls_dir .. '/lombok.jar',
        '-data', workspace_folder,
    },
    on_attach = on_attach,
    init_options = {
        bundles = bundles,
    }
}

jdtls.start_or_attach(config)
