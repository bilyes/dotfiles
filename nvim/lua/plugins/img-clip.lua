-- Clipboard images in project Markdown are handled by the smart `cp`
-- mapping in mappings.lua. Per-project rules live in `.img-clip.lua` at the
-- project root.
return {
    'HakonHarnes/img-clip.nvim',
    ft = 'markdown',
    config = function()
        require('img-clip').setup()
    end,
}
