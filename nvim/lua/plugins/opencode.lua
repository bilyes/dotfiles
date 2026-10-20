return {
    "nickjvandyke/opencode.nvim",
    dependencies = {
        -- Runs the OpenCode TUI in a floating terminal (see `opencode_terminal`).
        "akinsho/toggleterm.nvim",
    },
    config = function()
        -- Floating terminal running `opencode2` (OpenCode v2 with the work provider
        -- config). Created on first use.
        local terminal
        local function opencode_terminal()
            terminal = terminal or require("toggleterm.terminal").Terminal:new({
                cmd = "opencode2",
                direction = "float",
                hidden = true,
            })
            return terminal
        end

        ---@type opencode.Opts
        vim.g.opencode_opts = {
            server = {
                -- Called when no running OpenCode service is found; the plugin retries afterwards.
                start = function() opencode_terminal():open() end,
            },
        }

        -- Recommended/example keymaps.
        vim.keymap.set(
            { "n", "x" },
            "<leader>oc",
            function() require("opencode").ask("@this: ") end,
            { desc = "Ask opencode…" }
        )
        vim.keymap.set({ "n", "x" }, "<leader>ox", function() require("opencode").select() end,
            { desc = "Execute opencode action…" })
        vim.keymap.set({ "n", "t" }, "<C-.>", function() opencode_terminal():toggle() end, { desc = "Toggle opencode" })

        vim.keymap.set({ "n", "x" }, "go", function() return require("opencode").operator("@this") end,
            { desc = "Send range to opencode", expr = true })
        vim.keymap.set("n", "goo", function() return require("opencode").operator("@this") .. "_" end,
            { desc = "Send line to opencode", expr = true })

        -- toggleterm takes <C-x>, so increment/decrement live on +/- instead.
        vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
        vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
    end,
}
