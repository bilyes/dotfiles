local dap = require('dap')

local opts = { noremap=true, silent=true }
vim.keymap.set('n', '<leader>db', ':lua require("dap").toggle_breakpoint()<CR>', opts);
vim.keymap.set('n', '<leader>dB', ':lua require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))<CR>', opts);
vim.keymap.set('n', '<leader>dc', ':lua require("dap").continue()<CR>', opts);
vim.keymap.set('n', '<leader>dt', ':lua require("dap").terminate()<CR>', opts);
vim.keymap.set('n', '<leader>dsv', ':lua require("dap").step_over()<CR>', opts);
vim.keymap.set('n', '<leader>dsi', ':lua require("dap").step_into()<CR>', opts);
vim.keymap.set('n', '<leader>dso', ':lua require("dap").step_out()<CR>', opts);

local dapui = require('dapui')

dapui.setup({
    layouts = {
        {
            elements = {
                -- Elements can be strings or table with id and size keys.
                { id = "scopes", size = 0.25 },
                "breakpoints",
                 "stacks",
                 "watches",
            },
            size = 40, -- 40 columns
            position = "right",
        },
        {
            elements = {
                "console",
                "repl",
            },
            size = 0.25, -- 25% of total lines
            position = "bottom",
        },
    },
})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open {}
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close {}
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close {}
end
