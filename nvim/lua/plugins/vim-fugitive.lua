return {
    'tpope/vim-fugitive',
    cmd = {
        'G', 'Git', 'Gcd', 'Glcd', 'Ggrep', 'Glgrep', 'Gclog', 'GcLog', 'Gllog', 'GlLog',
        'Ge', 'Gedit', 'Gpedit', 'Gsplit', 'Gvsplit', 'Gtabedit', 'Gdrop', 'Gr', 'Gread',
        'Gdiffsplit', 'Ghdiffsplit', 'Gvdiffsplit', 'Gw', 'Gwrite', 'Gwq',
        'GRemove', 'GUnlink', 'GDelete', 'GMove', 'GRename', 'GBrowse',
    },
    keys = {
        { '<leader>gs',  function() vim.cmd.Git() end,                          desc = 'Git status' },
        { '<leader>ggp', function() vim.cmd.Git('push') end,                    desc = 'Git push' },
        { '<leader>gpf', function() vim.cmd.Git('push --force-with-lease') end, desc = 'Git push force' },
        { '<leader>ggl', function() vim.cmd.Git('pull') end,                    desc = 'Git pull' },
        -- Not silent: it leaves the command half-typed, which silent would hide until the first key
        { '<leader>gcob', ':G checkout -b ', desc = 'Git checkout new branch' },
    },
    -- In init, not config: diffopt applies to every diff (diffview, gitsigns), from startup
    init = function()
        -- Rebind fugitive's d2o/d3o (ours/theirs hunk in a merge diff) to gh/gl.
        vim.g.nremap = { d2o = 'gh', d3o = 'gl' }

        vim.opt.diffopt = vim.opt.diffopt + "vertical"
    end,
}
