---------------------
--- KEYBINDINGS ---
---------------------

-- See https://wiki.hypr.land/configuring/core/binds/

-- Duplicated from hyprland.lua (each require()d file is isolated).
local terminal = terminal or "kitty"
local fileManager = fileManager or "nautilus"
local menu = menu or "sh ~/.config/hypr/scripts/fuzzel.sh"
local mainMod = mainMod or "SUPER" -- Sets "Windows" key as main modifier

-- Example binds, see https://wiki.hypr.land/configuring/core/binds/ for more
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd("uwsm app -- " .. terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("uwsm app -- /usr/share/applications/firefox.desktop"))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.close())
-- hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("uwsm app -- " .. fileManager))
-- Two binds on one key run top-to-bottom (float, then center).
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + SHIFT + SPACE", hl.dsp.window.center())
-- hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind("ALT + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("sh ~/.config/hypr/scripts/fuzzel-open-file.sh"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("sh ~/.config/hypr/scripts/fuzzel-web-search.sh"))
-- hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle
-- hl.bind(mainMod .. " + SHIFT + J", hl.dsp.layout("togglesplit")) -- dwindle
hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd(terminal .. " -T clipse-clipboard -e clipse"))
-- hl.bind(mainMod .. " + C", hl.dsp.exec_cmd([[cliphist list | fuzzel --dmenu --with-nth 2 --prompt " " | cliphist decode | wl-copy]]))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(terminal .. " -T set-wallpaper -e ~/.config/dotfiles/scripts/setwall"))
hl.bind("CTRL + ALT + L", hl.dsp.exec_cmd("hyprlock"))
-- hl.bind(mainMod .. " + P", hl.dsp.exec_cmd([[grim -g "$(slurp -d)" - | wl-copy]]))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd([[grim -g "$(slurp -d -c '##ff0000ff')" -t ppm - | satty --filename - --output-filename ~/Pictures/Screenshots/satty-$(date '+%Y%m%d-%H:%M:%S').png]]))
hl.bind(mainMod .. " + SHIFT + M", hl.dsp.layout("swapwithmaster master"))

-- Move focus with mainMod + arrow keys (H/J/K/L)
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

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + BACKSLASH", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + BACKSLASH", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
-- hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
-- hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Zoom
hl.bind(mainMod .. " + SHIFT + equal", hl.dsp.exec_cmd("hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.2')"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.exec_cmd("hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.8) | if . < 1 then 1 else . end')"), { repeating = true })
hl.bind(mainMod .. " + SHIFT + 0", hl.dsp.exec_cmd("hyprctl -q keyword cursor:zoom_factor 1"))
