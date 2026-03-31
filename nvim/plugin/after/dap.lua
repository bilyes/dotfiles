vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg=0, fg='#993939', bg='#31353f' })
vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg=0, fg='#61afef', bg='#31353f' })
vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg=0, fg='#98c379', bg='#31353f' })

vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
vim.fn.sign_define('DapBreakpointCondition', { text='ﳁ', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl= 'DapBreakpoint' })
vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', linehl='DapLogPoint', numhl= 'DapLogPoint' })
vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })

local dap = require('dap')

local function opts(desc) return { noremap = true, silent = true, desc = desc } end
vim.keymap.set('n', '<leader>db', function() dap.toggle_breakpoint() end, opts('Toggle breakpoint'))
vim.keymap.set('n', '<leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, opts('Set conditional breakpoint'))
vim.keymap.set('n', '<leader>dc', function() dap.continue() end, opts('Continue'))
vim.keymap.set('n', '<leader>dt', function() dap.terminate() end, opts('Terminate'))
vim.keymap.set('n', '<leader>dsv', function() dap.step_over() end, opts('Step over'))
vim.keymap.set('n', '<leader>dsi', function() dap.step_into() end, opts('Step into'))
vim.keymap.set('n', '<leader>dso', function() dap.step_out() end, opts('Step out'))

local dapui = require('dapui')

vim.keymap.set('n', '<leader>de', function() dapui.eval() end, opts('Evaluate expression'))

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
