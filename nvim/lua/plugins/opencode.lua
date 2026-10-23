return {
    "nickjvandyke/opencode.nvim",
    dependencies = {
        -- Runs the OpenCode TUI in a floating terminal (see `opencode_terminal`).
        "akinsho/toggleterm.nvim",
    },
    config = function()
        -- Floating terminal running the OpenCode TUI, created on first use. Set
        -- vim.g.opencode_cmd (e.g. in plugins/local.lua) if the binary isn't `opencode`.
        local terminal
        local function opencode_terminal()
            terminal = terminal or require("toggleterm.terminal").Terminal:new({
                cmd = vim.g.opencode_cmd or "opencode",
                direction = "float",
                hidden = true,
                -- toggleterm maps <C-x> in every terminal it spawns. Remove it here so
                -- <C-x> reaches OpenCode, which uses it as its leader key.
                on_create = function(term)
                    pcall(vim.keymap.del, "t", "<C-x>", { buf = term.bufnr })
                end,
            })
            return terminal
        end

        ---@type opencode.Opts
        vim.g.opencode_opts = {
            server = {
                -- Called when no running OpenCode service is found; the plugin retries afterwards.
                -- Start it in the background: the prompt's @this comes from the current window
                -- once the server answers, so the float mustn't take focus. <C-.> shows it.
                start = function() opencode_terminal():spawn() end,
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
