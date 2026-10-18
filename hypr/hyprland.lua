-- Hyprland Lua config (0.55+). Converted from hyprlang .conf;
-- previous .conf configs are available in git history.
-- See https://wiki.hypr.land/Configuring/Start/

----------------
-- MY PROGRAMS --
----------------

-- NOTE: keybindings.lua defines its own locals with the same values because
-- each require()d file runs in an isolated scope. Keep them in sync.
terminal = "kitty"
fileManager = "nautilus"

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

-------------------
--- PERMISSIONS ---
-------------------

-- See https://wiki.hypr.land/configuring/core/advanced-configuration/permissions/
-- NOTE: permission changes require a Hyprland restart.

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission({ binary = "/usr/(bin|local/bin)/grim", type = "screencopy", mode = "allow" })
-- hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })
-- hl.permission({ binary = "/usr/(bin|local/bin)/hyprpm", type = "plugin", mode = "allow" })

----------------
--- MODULES ----
----------------

require("autostart")
require("envvars")
require("looks")
require("input")
require("keybindings")
require("rules")
