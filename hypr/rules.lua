------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------

-- See https://wiki.hypr.land/configuring/core/rules/
-- See https://wiki.hypr.land/configuring/core/rules/workspace-rules/ for workspace rules

hl.layer_rule({ match = { namespace = "waybar" }, blur = true })
hl.layer_rule({ match = { namespace = "waybar" }, ignore_alpha = 0.5 })

hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, ignore_alpha = 0.5 })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, ignore_alpha = 0.5 })

hl.window_rule({
  name = "Clipse Kitty",
  match = { class = "kitty", title = "clipse-clipboard" },
  float = true,
  size = { "monitor_w*0.21", "monitor_h*0.4" },
  opacity = "0.8",
  stay_focused = true,
  pin = true,
})

hl.window_rule({
  name = "Set Wallpaper Kitty",
  match = { class = "kitty", title = "set-wallpaper" },
  float = true,
  size = { "monitor_w*0.4", "monitor_h*0.4" },
  opacity = "0.8",
})

-- Center the satty screenshot editor
hl.window_rule({
  name = "Satty Screenshot Editor",
  match = { class = "com.gabm.satty" },
  float = true,
  center = true,
})

-- Firefox About window - always float centered, not tiled
hl.window_rule({
  name = "Firefox About",
  match = { class = "^(firefox|FirefoxPrivate)$", title = "^(About Mozilla Firefox)$" },
  float = true,
  center = true,
})

-- Thunderbird login / OAuth popups - float centered on current workspace
hl.window_rule({
  name = "Thunderbird Login Modal",
  match = { class = "org.mozilla.Thunderbird", modal = true },
  float = true,
  center = true,
})

hl.window_rule({
  name = "Thunderbird Login Float",
  match = { class = "org.mozilla.Thunderbird", float = true },
  center = true,
})

hl.window_rule({
  name = "Thunderbird OAuth Title",
  match = { class = "org.mozilla.Thunderbird", title = "^(Authentication Required.*|Sign in.*|Log in.*|.*OAuth.*|.*Google.*|.*Microsoft.*)$" },
  float = true,
  center = true,
})

hl.window_rule({
  match = { class = "org.mozilla.Thunderbird", float = false, modal = false },
  workspace = "4",
  no_initial_focus = true,
})
hl.window_rule({
  match = { class = "signal", title = "Signal" },
  workspace = "4",
  no_initial_focus = true,
})
hl.window_rule({
  match = { class = "heroic", title = "^(Heroic Games Launcher)$" },
  workspace = "5",
  no_initial_focus = true,
})
hl.window_rule({
  match = { class = "steam", title = "^(Steam)$" },
  workspace = "5",
  no_initial_focus = true,
})
hl.window_rule({
  match = { class = "Steam" },
  workspace = "5",
  no_initial_focus = true,
})
hl.window_rule({
  match = { class = "FirefoxPrivate", title = "(.*)(Mozilla Firefox)$", float = false, modal = false },
  workspace = "3",
  no_initial_focus = true,
})
hl.window_rule({
  match = { class = "^(Tor Browser)", title = "(.*)(Tor Browser)$" },
  workspace = "6",
  no_initial_focus = true,
})

hl.window_rule({
  match = { class = "^(qalculate-gtk)$" },
  float = true,
})

-- Remove black borders in Picture-in-Picture windows
hl.window_rule({
  match = { title = "^(Picture-in-Picture)$" },
  float = true,
})
-- hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, move = { "72%", "7%" } })
-- hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, size = { "monitor_w*0.4", "monitor_h*0.48" } })
-- hl.window_rule({ match = { title = "^(Picture-in-Picture)$" }, keep_aspect_ratio = true })

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})

-- Fix some dragging issues with XWayland
-- hl.window_rule({ match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false }, no_focus = true })
