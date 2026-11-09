local diary_folder = "main/diary"
local diary_entry_pattern = "^%d%d%d%d%-%d%d%-%d%d%.md$"

-- Opens the diary entry `step` entries away from the current one (negative goes back),
-- skipping days without an entry, or the farthest one if there are fewer. Unlike
-- `:Obsidian yesterday`, it never creates a note.
local function goto_diary_entry(step)
    local path = vim.api.nvim_buf_get_name(0)
    local dir, current = vim.fs.dirname(path), vim.fs.basename(path)
    -- Entries in the direction of travel, nearest first; YYYY-MM-DD names sort by date
    local entries = {}
    for name, type in vim.fs.dir(dir) do
        if type == "file" and name:match(diary_entry_pattern)
            and ((step < 0 and name < current) or (step > 0 and name > current)) then
            table.insert(entries, name)
        end
    end
    table.sort(entries, function(a, b)
        if step < 0 then
            return a > b
        end
        return a < b
    end)
    if #entries == 0 then
        vim.notify(("No %s diary entry"):format(step < 0 and "older" or "newer"))
        return
    end
    vim.cmd.edit(vim.fs.joinpath(dir, entries[math.min(math.abs(step), #entries)]))
end

return {
    "obsidian-nvim/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    -- obsidian.nvim picks its picker on first use, from what's on the runtimepath, and
    -- keeps that choice; Telescope is lazy-loaded, so load it first or obsidian falls
    -- back to its built-in picker.
    dependencies = { "nvim-telescope/telescope.nvim" },
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
    opts = {
        workspaces = {
            {
                name = "notes",
                path = "~/notes",
            },
        },

        frontmatter = {
            enabled = false,
        },

        ui = {
            enable = false,
        },

        checkbox = {
            --order = { " ", "~", "!", ">", "x" },
            order = { " ", "x" },
        },

        note_id_func = function(title)
            if title and title ~= "" then
                return title
            end
            -- obsidian.nvim needs a non-empty ID, e.g. for `:Obsidian new` without a title
            return require("obsidian.builtin").zettel_id()
        end,

        daily_notes = {
            folder = diary_folder,
        },

        picker = {
            name = "telescope.nvim",
        },

        link = {
            style = "markdown",
        },

        new_notes_location = "notes_subdir",

        legacy_commands = false, -- remove this after version 4

        callbacks = {
            enter_note = function(note)
                vim.keymap.set("n", "<tab>p", "<cmd>Obsidian quick_switch<cr>", {
                    buf = note.bufnr,
                    desc = "Quick switch",
                })
                vim.keymap.set("n", "<leader>fs", "<cmd>Obsidian search<cr>", {
                    buf = note.bufnr,
                    desc = "Search notes",
                })
                vim.keymap.set("n", "<leader>ta", "<cmd>Obsidian tags<cr>", {
                    buf = note.bufnr,
                    desc = "Show tags",
                })
                vim.keymap.set("n", "<leader>to", "<cmd>Obsidian today<cr>", {
                    buf = note.bufnr,
                    desc = "Open today's note",
                })
                vim.keymap.set("n", "<leader>ye", "<cmd>Obsidian yesterday<cr>", {
                    buf = note.bufnr,
                    desc = "Open yesterday's note",
                })
                -- <leader>gd (follow link) comes from plugin/lsp.lua through obsidian's LSP server
                vim.keymap.set("n", "<leader>ch", "<cmd>Obsidian toggle_checkbox<cr>", {
                    buf = note.bufnr,
                    desc = "Toggle checkbox",
                })

                local path = tostring(note.path)
                local diary_dir = vim.fs.joinpath(tostring(Obsidian.workspace.root), diary_folder)
                if vim.fs.normalize(vim.fs.dirname(path)) == vim.fs.normalize(diary_dir)
                    and vim.fs.basename(path):match(diary_entry_pattern) then
                    vim.keymap.set("n", "[j", function() goto_diary_entry(-vim.v.count1) end, {
                        buf = note.bufnr,
                        desc = "Previous diary entry",
                    })
                    vim.keymap.set("n", "]j", function() goto_diary_entry(vim.v.count1) end, {
                        buf = note.bufnr,
                        desc = "Next diary entry",
                    })
                end
            end,
        },
    },
}
