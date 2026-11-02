-- Hyprland Lua config (0.55+).
-- See https://wiki.hypr.land/Configuring/Start/
-- Environment variables live in ../uwsm/env and ../uwsm/env-hyprland.

----------------
--- MONITORS ---
----------------

-- See https://wiki.hypr.land/configuring/core/monitors/
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "auto",
})

hl.config({
  xwayland = {
    force_zero_scaling = true,
  },
})

----------------
--- MODULES ----
----------------

require("autostart")
require("looks")
require("input")
require("keybindings")
require("rules")

-- For Noctalia Color templates. Noctalia writes noctalia.lua (git-ignored) once it runs, and
-- Hyprland is what starts it, so the file is missing at a new machine's first start: skip it
-- then, but still report any other error from it.
local ok, noctalia = pcall(require, "noctalia")
if ok then
  noctalia.apply_theme()
elseif not tostring(noctalia):find("module 'noctalia' not found", 1, true) then
  error(noctalia, 0)
end
