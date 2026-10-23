---------------------
--- KEYBINDINGS ---
---------------------

-- See https://wiki.hypr.land/configuring/core/binds/

local terminal = "kitty"
local fileManager = "nautilus"
local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local ipc = "noctalia msg "

hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("uwsm app -- " .. terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("uwsm app -- /usr/share/applications/firefox.desktop"))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("uwsm app -- " .. fileManager))
-- Two binds on one key run top-to-bottom (float, then center).
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.center())

-- Noctalia launcher, panels, screenshots, session
hl.bind("ALT + Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher /fs"))
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center notifications"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(ipc .. "panel-toggle clipboard"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(ipc .. "panel-toggle wallpaper"))
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd(ipc .. "session lock"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(ipc .. "screenshot-region"))
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))

hl.bind(mainMod .. " + SHIFT + M", hl.dsp.layout("swapwithmaster master"))

-- Move focus with mainMod + H/J/K/L
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))

-- Switch workspaces with CTRL + [0-9]
hl.bind("CTRL + 1", hl.dsp.focus({ workspace = 1 }))
hl.bind("CTRL + 2", hl.dsp.focus({ workspace = 2 }))
hl.bind("CTRL + 3", hl.dsp.focus({ workspace = 3 }))
hl.bind("CTRL + 4", hl.dsp.focus({ workspace = 4 }))
hl.bind("CTRL + 5", hl.dsp.focus({ workspace = 5 }))
hl.bind("CTRL + 6", hl.dsp.focus({ workspace = 6 }))
hl.bind("CTRL + 7", hl.dsp.focus({ workspace = 7 }))
hl.bind("CTRL + 8", hl.dsp.focus({ workspace = 8 }))
hl.bind("CTRL + 9", hl.dsp.focus({ workspace = 9 }))
hl.bind("CTRL + 0", hl.dsp.focus({ workspace = 10 }))

-- Move active window to a workspace with CTRL + SHIFT + [0-9]
hl.bind("CTRL + SHIFT + 1", hl.dsp.window.move({ workspace = 1 }))
hl.bind("CTRL + SHIFT + 2", hl.dsp.window.move({ workspace = 2 }))
hl.bind("CTRL + SHIFT + 3", hl.dsp.window.move({ workspace = 3 }))
hl.bind("CTRL + SHIFT + 4", hl.dsp.window.move({ workspace = 4 }))
hl.bind("CTRL + SHIFT + 5", hl.dsp.window.move({ workspace = 5 }))
hl.bind("CTRL + SHIFT + 6", hl.dsp.window.move({ workspace = 6 }))
hl.bind("CTRL + SHIFT + 7", hl.dsp.window.move({ workspace = 7 }))
hl.bind("CTRL + SHIFT + 8", hl.dsp.window.move({ workspace = 8 }))
hl.bind("CTRL + SHIFT + 9", hl.dsp.window.move({ workspace = 9 }))
hl.bind("CTRL + SHIFT + 0", hl.dsp.window.move({ workspace = 10 }))

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + BACKSLASH", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + BACKSLASH", hl.dsp.window.move({ workspace = "special:magic" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Volume / brightness keys (Noctalia OSD); repeat while held and work on the lock screen
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })

-- Media control
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(ipc .. "media next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(ipc .. "media toggle"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(ipc .. "media toggle"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(ipc .. "media previous"), { locked = true })

-- Zoom. `hyprctl keyword` doesn't work with the Lua config, so set the option directly.
local function zoom(factor)
  return function()
    local current = factor and hl.get_config("cursor.zoom_factor") * factor or 1
    hl.config({ cursor = { zoom_factor = math.max(1, math.min(10, current)) } }) -- allowed: 1-10
  end
end
hl.bind(mainMod .. " + SHIFT + equal", zoom(1.2), { repeating = true })
hl.bind(mainMod .. " + SHIFT + minus", zoom(0.8), { repeating = true })
hl.bind(mainMod .. " + SHIFT + 0", zoom())
