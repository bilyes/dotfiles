-- :TodoCapture opens a small floating window to type todos in. Saving it (:w, :wq, :x, ZZ) adds
-- each non-empty line to `todo_file` as an unchecked checkbox, newest first, below the heading on
-- its first line. :q! cancels. A bare :w empties the window for the next todo instead of closing it.
--
-- `:TodoCapture here` uses the current window instead of a floating one, without a statusline:
-- tmux's prefix t runs it in a Neovim of its own, in a popup that draws its own border and title.

local todo_file = "~/notes/todo.md"
local capture_name = "todo://capture"

local capture_buf

local function is_blank(line)
    return line:match("^%s*$") ~= nil
end

local function is_list_item(line)
    return line:match("^%s*[-*+]%s") ~= nil or line:match("^%s*%d+[.)]%s") ~= nil
end

-- The text of a typed line, without the "- [ ] " or "- " it may already start with
local function to_item(line)
    return (vim.trim(line):gsub("^[-*+]%s+%[.%]%s*", ""):gsub("^[-*+]%s+", ""))
end

-- Where in `lines` the new items go, and the lines to insert there. Those are the items, plus a
-- blank line after the heading if it has none, and one before plain text that follows: without
-- it, Markdown would make that text part of the last item.
local function plan_insert(lines, items)
    local at, block = 0, {}
    if lines[1] and lines[1]:match("^#+%s") then
        at = 1
        if lines[2] and is_blank(lines[2]) then
            at = 2
        else
            table.insert(block, "")
        end
    end
    for _, item in ipairs(items) do
        table.insert(block, "- [ ] " .. item)
    end
    local following = lines[at + 1]
    if following and not is_blank(following) and not is_list_item(following) then
        table.insert(block, "")
    end
    return at, block
end

local function loaded_buffer(path)
    local real = vim.uv.fs_realpath(path)
    if not real then
        return nil
    end
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        local name = vim.api.nvim_buf_get_name(buf)
        if vim.api.nvim_buf_is_loaded(buf) and name ~= "" and vim.uv.fs_realpath(name) == real then
            return buf
        end
    end
end

local function add_todos(items)
    local path = vim.fn.expand(todo_file)
    -- Through the buffer when the todo file is open, so it doesn't go out of sync with the file
    local buf = loaded_buffer(path)
    if buf then
        local modified = vim.bo[buf].modified
        if not modified then
            vim.cmd.checktime(tostring(buf))
        end
        local at, block = plan_insert(vim.api.nvim_buf_get_lines(buf, 0, -1, false), items)
        vim.api.nvim_buf_set_lines(buf, at, at, false, block)
        if modified then
            vim.notify(todo_file .. " has unsaved changes, so the todos were added without saving it",
                vim.log.levels.WARN)
        else
            vim.api.nvim_buf_call(buf, function() vim.cmd("silent write") end)
        end
        return
    end

    local lines = vim.uv.fs_stat(path) and vim.fn.readfile(path) or {}
    local at, block = plan_insert(lines, items)
    for i, line in ipairs(block) do
        table.insert(lines, at + i, line)
    end
    vim.fn.writefile(lines, path)
end

local function save(buf)
    local items = {}
    for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
        local item = to_item(line)
        if item ~= "" then
            table.insert(items, item)
        end
    end
    if #items > 0 then
        add_todos(items)
        -- So that writing again doesn't add the same todos twice
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, {})
        vim.notify(("Added %d todo%s to %s"):format(#items, #items == 1 and "" or "s", todo_file))
    end
    vim.bo[buf].modified = false
end

local function open_float(buf)
    local width = math.min(80, vim.o.columns - 4)
    local height = 3
    return vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        -- Centered, counting the border
        row = math.floor((vim.o.lines - height - 2) / 2),
        col = math.floor((vim.o.columns - width - 2) / 2),
        style = "minimal",
        title = " New todo ",
        title_pos = "center",
        footer = " :wq to add, :q! to cancel ",
        footer_pos = "center",
    })
end

local function open(here)
    if capture_buf and vim.api.nvim_buf_is_valid(capture_buf) then
        local win = vim.fn.bufwinid(capture_buf)
        if win ~= -1 then
            vim.api.nvim_set_current_win(win)
            vim.cmd.startinsert()
            return
        end
        vim.api.nvim_buf_delete(capture_buf, { force = true })
    end

    local buf = vim.api.nvim_create_buf(false, true)
    capture_buf = buf
    vim.api.nvim_buf_set_name(buf, capture_name)
    -- Lets :w run the BufWriteCmd below rather than fail, as it would in a scratch buffer
    vim.bo[buf].buftype = "acwrite"
    vim.bo[buf].bufhidden = "wipe"
    vim.api.nvim_create_autocmd("BufWriteCmd", {
        buffer = buf,
        callback = function() save(buf) end,
    })

    local win
    if here then
        win = vim.api.nvim_get_current_win()
        vim.api.nvim_win_set_buf(win, buf)
        vim.wo[win].number = false
        vim.wo[win].relativenumber = false
        vim.wo[win].signcolumn = "no"
        vim.wo[win].colorcolumn = ""
        -- No ~ past the last line, as in the floating window
        vim.wo[win].fillchars = "eob: "
        -- Global, as this Neovim only runs the capture. Without a statusline, the ruler would
        -- show in the command line instead.
        vim.o.laststatus = 0
        vim.o.ruler = false
    else
        win = open_float(buf)
    end

    -- After the window opens, so the window options ftplugin/markdown.lua sets apply to it
    vim.bo[buf].filetype = "markdown"
    -- Hard-wrapping a long todo would split it into two
    vim.bo[buf].textwidth = 0
    vim.wo[win].wrap = true
    vim.wo[win].linebreak = true
    vim.cmd.startinsert()
end

vim.api.nvim_create_user_command("TodoCapture", function(opts)
    if opts.args ~= "" and opts.args ~= "here" then
        vim.notify("TodoCapture: unknown argument " .. opts.args, vim.log.levels.ERROR)
        return
    end
    open(opts.args == "here")
end, {
    nargs = "?",
    complete = function() return { "here" } end,
    desc = "Capture todos into " .. todo_file,
})
