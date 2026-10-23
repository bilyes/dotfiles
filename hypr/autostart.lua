-----------------
--- AUTOSTART ---
-----------------

-- See https://wiki.hypr.land/configuring/core/autostart/
-- exec-once semantics: run only on first launch (not on every reload).

-- Noctalia provides the bar, notifications, wallpaper, idle and lock screen. uwsm runs it as
-- its own unit, in the session slice, rather than inside Hyprland's, where one out-of-memory
-- kill would end the session (noctalia/config.toml does the same for the apps it launches).
hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm app -s s -- noctalia")
end)
