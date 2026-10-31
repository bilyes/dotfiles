---------------------
--- LOOK AND FEEL ---
---------------------

-- Refer to https://wiki.hypr.land/configuring/core/config-options/

-- https://wiki.hypr.land/configuring/core/config-options/#general
hl.config({
  general = {
    gaps_in = 3,
    gaps_out = 5,

    border_size = 0,

    col = {
      active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },

    -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = true,

    -- Please see https://wiki.hypr.land/configuring/extra/tearing/ before you turn this on
    allow_tearing = false,

    -- layout = "dwindle"
    layout = "master",
  },
})

-- https://wiki.hypr.land/configuring/core/config-options/#decoration
hl.config({
  decoration = {
    rounding = 10,
    rounding_power = 2,

    -- Change transparency of focused and unfocused windows
    active_opacity = 1.0,
    inactive_opacity = 1.0,

    -- Dim the workspace behind the scratchpad (any special workspace) while it's open
    dim_special = 0.6,

    shadow = {
      enabled = false,
      range = 4,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },

    -- https://wiki.hypr.land/configuring/core/config-options/#blur
    blur = {
      enabled = true,
      size = 5,
      passes = 2,
    },
  },
})

-- https://wiki.hypr.land/configuring/core/config-options/#animations
hl.config({
  animations = {
    enabled = true,
  },
})

-- Default animations, see https://wiki.hypr.land/configuring/core/animations/ for more
hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 1.94, bezier = "almostLinear", style = "fade" })
-- The scratchpad drops down from the top and goes back up. The style names the edge the slide
-- is measured from, not the direction, so "slide bottom" leaves upwards.
hl.animation({ leaf = "specialWorkspaceIn", enabled = true, speed = 3, bezier = "easeOutQuint", style = "slide top" })
hl.animation({ leaf = "specialWorkspaceOut", enabled = true, speed = 2, bezier = "easeOutQuint", style = "slide bottom" })

-- Ref https://wiki.hypr.land/configuring/core/rules/workspace-rules/
-- Default workspace per monitor
hl.workspace_rule({ workspace = "10", monitor = "eDP-1", default = true })
hl.workspace_rule({ workspace = "1", monitor = "HDMI-A-2", default = true })

-- See https://wiki.hypr.land/configuring/layouts/dwindle-layout/ for more
hl.config({
  dwindle = {
    -- pseudotile = true -- Master switch for pseudotiling.
    preserve_split = false, -- You probably want this
    -- use_active_for_splits = false,
  },
})

-- See https://wiki.hypr.land/configuring/layouts/master-layout/ for more
hl.config({
  master = {
    -- new_status = "slave",
    allow_small_split = true,
    special_scale_factor = 0.8, -- scratchpad windows at 80%, so the dimmed workspace shows around them
    mfact = 0.4,
    orientation = "center",
    -- inherit_fullscreen = false,
  },
})

-- https://wiki.hypr.land/configuring/core/config-options/#misc
hl.config({
  misc = {
    force_default_wallpaper = -1, -- Set to 0 or 1 to disable the anime mascot wallpapers
    disable_hyprland_logo = true,
  },
})
