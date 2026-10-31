-- Paste images into Markdown from the clipboard. Per-project behavior lives
-- in a .img-clip.lua at the project root; <leader>p is only bound in Markdown
-- buffers whose tree holds one, so it stays out of the way everywhere else.
return {
    "HakonHarnes/img-clip.nvim",
    ft = "markdown",
    config = function(_, opts)
        require("img-clip").setup(opts)

        local group = vim.api.nvim_create_augroup("ImgClipProject", { clear = true })

        local function attach(buf)
            if vim.bo[buf].filetype ~= "markdown" then
                return
            end
            local name = vim.api.nvim_buf_get_name(buf)
            if name == "" then
                return
            end
            local dir = vim.fs.dirname(name)
            while dir ~= "" and vim.fn.isdirectory(dir) == 0 do
                dir = vim.fs.dirname(dir)
            end
            if dir == "" then
                return
            end
            local found = vim.fs.find(".img-clip.lua", { upward = true, path = dir })
            if #found == 0 then
                return
            end
            vim.keymap.set("n", "<leader>p", function()
                local ok, project = pcall(dofile, found[1])
                if not ok or type(project) ~= "table" then
                    vim.notify("img-clip: could not load " .. found[1], vim.log.levels.ERROR)
                    return
                end
                require("img-clip").paste_image(project)
            end, { buffer = buf, nowait = true, desc = "Paste image" })
        end

        vim.api.nvim_create_autocmd("FileType", {
            pattern = "markdown",
            group = group,
            callback = function()
                attach(vim.api.nvim_get_current_buf())
            end,
        })
        attach(vim.api.nvim_get_current_buf())
    end,
}
