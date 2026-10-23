return {
    'github/copilot.vim',
    -- Set before copilot.vim loads: that's when it decides, from copilot_no_tab_map,
    -- whether to map <Tab>.
    init = function()
        -- Every other filetype keeps copilot.vim's default (enabled)
        vim.g.copilot_filetypes = {
            markdown = false,
        }
        vim.g.copilot_no_tab_map = true
        vim.g.copilot_npx_command = 0 -- use bundled language-server.js instead of npx

        vim.g.copilot_lsp_settings = {
            telemetry = {
                telemetryLevel = "off",
            },
        }
    end,
    config = function()
        local opts = { silent = true, noremap = true, expr = true, replace_keycodes = false }
        vim.keymap.set('i', '<C-a>', 'copilot#Accept("<CR>")', opts)
        vim.keymap.set('i', '<C-f>', 'copilot#Next()', opts)
        -- Back, as <C-f> is forward; leaves <C-s> to Neovim's signature help
        vim.keymap.set('i', '<C-b>', 'copilot#Previous()', opts)
    end
}
