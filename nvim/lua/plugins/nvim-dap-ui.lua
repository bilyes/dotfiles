return {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    keys = {
        { '<leader>db', function() require('dap').toggle_breakpoint() end, desc = 'Toggle breakpoint' },
        { '<leader>dB', function() require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = 'Set conditional breakpoint' },
        { '<leader>dc', function() require('dap').continue() end, desc = 'Continue' },
        { '<leader>dt', function() require('dap').terminate() end, desc = 'Terminate' },
        { '<leader>dsv', function() require('dap').step_over() end, desc = 'Step over' },
        { '<leader>dsi', function() require('dap').step_into() end, desc = 'Step into' },
        { '<leader>dso', function() require('dap').step_out() end, desc = 'Step out' },
        { '<leader>de', function() require('dapui').eval() end, desc = 'Evaluate expression' },
    },
    config = function()
        vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg=0, fg='#993939', bg='#31353f' })
        vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg=0, fg='#61afef', bg='#31353f' })
        vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg=0, fg='#98c379', bg='#31353f' })

        vim.fn.sign_define('DapBreakpoint', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
        vim.fn.sign_define('DapBreakpointCondition', { text='ﳁ', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl='DapBreakpoint' })
        vim.fn.sign_define('DapBreakpointRejected', { text='', texthl='DapBreakpoint', linehl='DapBreakpoint', numhl= 'DapBreakpoint' })
        vim.fn.sign_define('DapLogPoint', { text='', texthl='DapLogPoint', linehl='DapLogPoint', numhl= 'DapLogPoint' })
        vim.fn.sign_define('DapStopped', { text='', texthl='DapStopped', linehl='DapStopped', numhl= 'DapStopped' })

        local dap = require('dap')
        local dapui = require('dapui')

        dapui.setup({
            layouts = {
                {
                    elements = {
                        { id = "scopes", size = 0.25 },
                        "breakpoints",
                         "stacks",
                         "watches",
                    },
                    size = 40,
                    position = "right",
                },
                {
                    elements = {
                        "console",
                        "repl",
                    },
                    size = 0.25,
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
    end,
}
