local cur_branch = vim.fn.system('git rev-parse --abbrev-ref HEAD | tr -d "\n"')

vim.keymap.set('n', '<leader>gs', vim.cmd.Git, opts)
vim.keymap.set('n', '<leader>ggp', function() vim.cmd.Git('push') end, opts)
vim.keymap.set('n', '<leader>gpf', function() vim.cmd.Git('push -f') end, opts)
vim.keymap.set('n', '<leader>ggl', function() vim.cmd.Git('pull') end, opts)
vim.keymap.set('n', '<leader>gcob', ':G checkout -b ', opts)
vim.keymap.set('n', '<leader>gpu', function() vim.cmd.Git('push -u origin ' .. cur_branch) end, opts)
