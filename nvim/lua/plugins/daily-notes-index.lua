return {
    "bilyes/daily-notes-index.nvim",
    opts = {
        daily_notes_folder = "~/notes/main/diary",
        index_filename = "diary.md",
        index_title = "Diary Index",
    },
    keys = {
        { "<leader>di", ":DailyNotesIndex open<CR>", desc = "Open daily notes index" }
    },
    lazy = false
}
