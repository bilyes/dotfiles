-----------------
--- AUTOSTART ---
-----------------

-- See https://wiki.hypr.land/configuring/core/autostart/
-- exec-once semantics: run only on first launch (not on every reload).

-- exec-once = $terminal
-- exec-once = nm-applet &
-- exec-once = waybar & hyprpaper & firefox

-- TODO fix XDG_CONFIG_HOME
-- use systemctl --user enable --now some-service.service when using UWSM
-- exec-once = waybar & swaync & hyprpaper & hypridle
hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm app -- clipse -listen")
end)
