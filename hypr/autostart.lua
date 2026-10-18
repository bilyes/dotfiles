-----------------
--- AUTOSTART ---
-----------------

-- See https://wiki.hypr.land/configuring/core/autostart/
-- exec-once semantics: run only on first launch (not on every reload).

-- Noctalia provides the bar, notifications, wallpaper, idle and lock screen.
hl.on("hyprland.start", function()
  hl.exec_cmd("noctalia")
end)
