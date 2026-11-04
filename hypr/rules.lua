------------------------------
--- WINDOWS AND WORKSPACES ---
------------------------------

-- See https://wiki.hypr.land/configuring/core/rules/
-- See https://wiki.hypr.land/configuring/core/rules/workspace-rules/ for workspace rules

-- The eDP-1 connector exists on the laptop whether or not a screen is plugged in. Card
-- numbering can shift between boots, so check the first few.
local function has_connector(name)
  for card = 0, 3 do
    local f = io.open(("/sys/class/drm/card%d-%s/status"):format(card, name))
    if f then
      f:close()
      return true
    end
  end
  return false
end

-- Workspaces 1-9 on the external display, 10 on the laptop panel. Only on that machine:
-- elsewhere these rules would still reserve 1-10, so the monitor would start on workspace 11.
if has_connector("eDP-1") then
  hl.workspace_rule({ workspace = "10", monitor = "eDP-1", default = true, persistent = true })
  for i = 1, 9 do
    hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-2", default = i == 1, persistent = i <= 4 })
  end
end

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
-- Older Steam clients use the class "Steam"
hl.window_rule({
  match = { class = "^([Ss]team)$" },
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

-- Float Picture-in-Picture windows
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
