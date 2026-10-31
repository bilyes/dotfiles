---------------------
--- KEYBINDINGS ---
---------------------

-- See https://wiki.hypr.land/configuring/core/binds/
-- Every bind has a description, and the numbered comments are categories: the Keymap plugin
-- (mainMod + /) lists and searches them.

local terminal = "kitty"
local fileManager = "nautilus"
local mainMod = "SUPER" -- Sets "Windows" key as main modifier
local ipc = "noctalia msg "

-- 1. Applications
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("uwsm app -- " .. terminal), { description = "Terminal" })
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("uwsm app -- /usr/share/applications/firefox.desktop"), { description = "Firefox" })
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("uwsm app -- " .. fileManager), { description = "File manager" })

-- 2. Noctalia
hl.bind("ALT + Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"), { description = "Launcher" })
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher /fs"), { description = "File search" })
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd(ipc .. "panel-toggle control-center notifications"), { description = "Notifications" })
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(ipc .. "panel-toggle clipboard"), { description = "Clipboard history" })
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(ipc .. "panel-toggle wallpaper"), { description = "Wallpaper picker" })
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd(ipc .. "session lock"), { description = "Lock screen" })
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd(ipc .. "screenshot-region"), { description = "Screenshot a region" })
-- The OCR bar widget handles this. "focused", not "all": with "all", the widget on every
-- monitor's bar would start its own region selection.
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.exec_cmd(ipc .. "plugin fel/ocr:ocr focused ocr-region"), { description = "Copy the text in a region (OCR)" })
hl.bind(mainMod .. " + comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"), { description = "Noctalia settings" })
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd(ipc .. "panel-toggle blackbartblues/keymap:panel"), { description = "Keybindings" })

-- 3. Windows
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.close(), { description = "Close window" })
-- Two binds on one key run top-to-bottom (float, then center).
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }), { description = "Toggle floating" })
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.center(), { description = "Center window" })
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.layout("swapwithmaster master"), { description = "Swap with master" })

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }), { description = "Focus left" })
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }), { description = "Focus right" })
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }), { description = "Focus down" })
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }), { description = "Focus up" })

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true, description = "Move window" })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true, description = "Resize window" })

-- 4. Workspaces
-- CTRL + [0-9] switches workspace, CTRL + SHIFT + [0-9] moves the active window there; 0 is 10
for i = 1, 10 do
  local key = tostring(i % 10)
  hl.bind("CTRL + " .. key, hl.dsp.focus({ workspace = i }), { description = "Switch to workspace " .. i })
  hl.bind("CTRL + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }), { description = "Move window to workspace " .. i })
end

-- Special workspace (scratchpad)
hl.bind(mainMod .. " + BACKSLASH", hl.dsp.workspace.toggle_special("magic"), { description = "Scratchpad" })
hl.bind(mainMod .. " + SHIFT + BACKSLASH", hl.dsp.window.move({ workspace = "special:magic" }), { description = "Move window to scratchpad" })

-- 5. Volume and brightness
-- Noctalia shows the OSD; the keys repeat while held and work on the lock screen
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(ipc .. "volume-up"), { locked = true, repeating = true, description = "Volume up" })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(ipc .. "volume-down"), { locked = true, repeating = true, description = "Volume down" })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(ipc .. "volume-mute"), { locked = true, repeating = true, description = "Mute" })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(ipc .. "brightness-up"), { locked = true, repeating = true, description = "Brightness up" })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(ipc .. "brightness-down"), { locked = true, repeating = true, description = "Brightness down" })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true, description = "Mute microphone" })
hl.bind("XF86HomePage", hl.dsp.exec_cmd("voxtype record toggle"), { locked = true, repeating = true, description = "Record" })

-- 6. Media
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(ipc .. "media next"), { locked = true, description = "Next track" })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd(ipc .. "media toggle"), { locked = true, description = "Play/pause" })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(ipc .. "media toggle"), { locked = true, description = "Play/pause" })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(ipc .. "media previous"), { locked = true, description = "Previous track" })

-- 7. Zoom
-- `hyprctl keyword` doesn't work with the Lua config, so set the option directly.
local function zoom(factor)
  return function()
    local current = factor and hl.get_config("cursor.zoom_factor") * factor or 1
    hl.config({ cursor = { zoom_factor = math.max(1, math.min(10, current)) } }) -- allowed: 1-10
  end
end
hl.bind(mainMod .. " + SHIFT + equal", zoom(1.2), { repeating = true, description = "Zoom in" })
hl.bind(mainMod .. " + SHIFT + minus", zoom(0.8), { repeating = true, description = "Zoom out" })
hl.bind(mainMod .. " + SHIFT + 0", zoom(), { description = "Reset zoom" })
