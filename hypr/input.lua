-------------
--- INPUT ---
-------------

-- Apple internal keyboard:
-- left Option <-> left Command; right Option -> right Control.
-- Hyprland 0.57 resolves keybind modifiers against the GLOBAL keymap, so the
-- remap must live in `input.kb_options` to affect binds. Detection against
-- /proc/bus/input/devices keeps shared dotfiles from swapping keys on machines
-- without this Apple keyboard.
local apple_keyboard = false
do
  local f = io.open("/proc/bus/input/devices", "r")
  if f then
    local contents = f:read("*a")
    f:close()
    if contents and contents:find("Apple Internal Keyboard", 1, true) then
      apple_keyboard = true
    end
  end
end

-- https://wiki.hypr.land/configuring/core/config-options/#input
hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = apple_keyboard and "altwin:swap_lalt_lwin,ctrl:ralt_rctrl" or "",
    kb_rules = "",

    -- Key repeat: start after 300 ms, then 30 repeats per second (was `xset r rate 200 30`)
    repeat_delay = 300,
    repeat_rate = 30,

    follow_mouse = 1,

    sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

    touchpad = {
      natural_scroll = false,
    },
  },
})
