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

-- For Noctalia Color templates
require("noctalia").apply_theme()
