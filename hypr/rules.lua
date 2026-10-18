------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------

-- See https://wiki.hypr.land/configuring/core/rules/
-- See https://wiki.hypr.land/configuring/core/rules/workspace-rules/ for workspace rules

-- Noctalia shell surfaces: no animations, translucent blur
hl.layer_rule({
  name = "noctalia",
  match = {
    namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$",
  },
  no_anim = true,
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
})
hl.window_rule({
  match = { class = "dev.noctalia.Noctalia" },
  float = true,
  size = { 1080, 920 },
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

-- Ignore maximize requests from apps. You'll probably like this.
hl.window_rule({
  name = "suppress-maximize-events",
  match = { class = ".*" },
  suppress_event = "maximize",
})
