-- Function to build index content from entries
local function build_index_content(entries)
    local content = "# Diary\n"
    local last_year = nil
    local last_month = nil

    for _, entry in ipairs(entries) do
        if entry.year ~= last_year then
            content = content .. string.format("\n## %d\n", entry.year)
            last_year = entry.year
            last_month = nil
        end

        if entry.month_name ~= last_month then
            content = content .. string.format("\n### %s\n\n", entry.month_name)
            last_month = entry.month_name
        end

        content = content .. entry.link .. "\n"
    end

    -- remove the trailing newline
    content = content:gsub("\n$", "")

    return content
end

-- Function to update diary index when new daily notes are written
local function update_diary_index_on_write(note, index_path)
    -- Validate note and convert path to string for operations
    if not note or not note.path then
        return -- No note or no path
    end

    local path_str = tostring(note.path)

    -- Parse date components
    local year, month, day = path_str:match("(%d%d%d%d)%-?(%d%d)%-?(%d%d)")
    if not year or not month or not day then
        return -- Invalid date format
    end

    -- Convert to numbers
    year = tonumber(year)
    month = tonumber(month)
    day = tonumber(day)

    -- Validate date components
    if year < 2000 or year > 2100 or month < 1 or month > 12 or day < 1 or day > 31 then
        return -- Invalid date range
    end

    -- Get day name
    local time = os.time({ year = year, month = month, day = day })
    local day_name = os.date("%A", time)

    -- Format the link text
    local link_text = string.format("%s-%s-%s - %s", year,
        string.format("%02d", month), string.format("%02d", day), day_name)

    -- Create the markdown link with relative path
    local note_link = string.format("- [%s](%s)", link_text, path_str:gsub("%.md$", ""))

    -- Read existing index or create new one
    local index_content = ""
    if vim.fn.filereadable(index_path) == 1 then
        index_content = table.concat(vim.fn.readfile(index_path), "\n")
    else
        index_content = "# Diary\n"
    end

    -- Parse existing entries to check for duplicates
    local entries = {}
    local lines = vim.split(index_content, "\n")
    local current_year = nil
    local current_month = nil

    for _, line in ipairs(lines) do
        -- Capture year headers
        local year_match = line:match("^## (%d%d%d%d)$")
        if year_match then
            current_year = tonumber(year_match)
            current_month = nil
            goto continue
        end

        -- Capture month headers
        local month_match = line:match("^### (.+)$")
        if month_match and current_year then
            current_month = month_match
            goto continue
        end

        -- Capture note entries
        local note_entry = line:match("^%- %[([^%]]+)%]%(([^)]+)%)$")
        if note_entry and current_year and current_month then
            -- Extract date from the entry
            local entry_date_str = note_entry:match("(%d%d%d%d%-%d%d%-%d%d)")
            if entry_date_str then
                local entry_year, entry_month, entry_day = entry_date_str:match("(%d%d%d%d)%-(%d%d)%-(%d%d)")
                if entry_year and entry_month and entry_day then
                    table.insert(entries, {
                        year = tonumber(entry_year),
                        month = tonumber(entry_month),
                        day = tonumber(entry_day),
                        link = line,
                        month_name = current_month
                    })
                end
            end
        end

        ::continue::
    end

    -- Check if this entry already exists
    for _, entry in ipairs(entries) do
        if entry.year == year and entry.month == month and entry.day == day then
            -- Don't add if it's a duplicate
            return
        end
    end

    -- Add new entry
    local month_names = { "January", "February", "March", "April", "May", "June",
        "July", "August", "September", "October", "November", "December" }
    local month_name = month_names[month]

    table.insert(entries, {
        year = year,
        month = month,
        day = day,
        link = note_link,
        month_name = month_name
    })

    -- Sort entries by date (reverse chronological)
    table.sort(entries, function(a, b)
        if a.year ~= b.year then
            return a.year > b.year
        elseif a.month ~= b.month then
            return a.month > b.month
        else
            return a.day > b.day
        end
    end)

    local new_content = build_index_content(entries)

    -- Write the updated index
    vim.fn.writefile(vim.split(new_content, "\n"), index_path)
end

local function is_daily_note(note)
    local path_str = tostring(note.path)

    local daily_folder = Obsidian.opts.daily_notes.folder

    -- Check if this is a daily note in the configured folder
    return path_str:match(daily_folder:gsub("[%^%$%(%)%%%.%[%]%*%+%-%?]", "%%%0"))
end

local function get_diary_index_path()
    local workspace_path = tostring(Obsidian.workspace.path)
    local daily_folder = Obsidian.opts.daily_notes.folder
    return workspace_path .. "/" .. daily_folder .. "/diary.md"
end

return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    --ft = "markdown",
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    event = {
        -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
        -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
        "BufReadPre " .. vim.fn.expand "~" .. "/notes/**.md",
        "BufNewFile " .. vim.fn.expand "~" .. "/notes/**.md",
        --"BufReadPre path/to/my-vault/**.md",
        --"BufNewFile path/to/my-vault/**.md",
    },
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    opts = {
        workspaces = {
            {
                name = "notes",
                path = "~/notes",
            },
            --{
            --name = "work",
            --path = "~/vaults/work",
            --},
        },

        frontmatter = {
            enabled = false,
        },

        ui = {
            enable = false,
        },

        note_id_func = function(title)
            return title
        end,

        daily_notes = {
            folder = "main/diary",
        },

        preferred_link_style = "markdown",

        new_notes_location = "notes_subdir",

        legacy_commands = false, -- remove this after version 4

        callbacks = {
            enter_note = function(note)
                vim.keymap.set("n", "<tab>p", "<cmd>Obsidian quick_switch<cr>", {
                    buffer = note.bufnr,
                    desc = "Quick switch",
                })
                vim.keymap.set("n", "<leader>fs", "<cmd>Obsidian search<cr>", {
                    buffer = note.bufnr,
                    desc = "Search notes",
                })
                vim.keymap.set("n", "<leader>ta", "<cmd>Obsidian tags<cr>", {
                    buffer = note.bufnr,
                    desc = "Show tags",
                })
                vim.keymap.set("n", "<leader>to", "<cmd>Obsidian today<cr>", {
                    buffer = note.bufnr,
                    desc = "Open today's note",
                })
                vim.keymap.set("n", "<leader>gd", "<cmd>Obsidian follow_link<cr>", {
                    buffer = note.bufnr,
                    desc = "Follow link under cursor",
                })
                vim.keymap.set("n", "<leader>ch", "<cmd>Obsidian toggle_checkbox<cr>", {
                    buffer = note.bufnr,
                    desc = "Toggle checkbox",
                })
            end,
            pre_write_note = function(note)
                local success, err = pcall(function()
                    if not is_daily_note(note) then
                        return
                    end

                    local index_path = get_diary_index_path()
                    update_diary_index_on_write(note, index_path)
                end)
                if not success then
                    vim.notify("Error updating diary index: " .. (err or "unknown"), vim.log.levels.ERROR)
                end
            end,
        },
    },
}
