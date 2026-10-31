-------------
--- INPUT ---
-------------

-- https://wiki.hypr.land/configuring/core/config-options/#input
hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
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

-- Apple internal keyboard:
-- left Option <-> left Command; right Option -> right Control.
-- See http://wiki.hypr.land/configuring/core/devices/ for more
hl.device({
  name = "apple-inc.-apple-internal-keyboard-/-trackpad",
  kb_options = "altwin:swap_lalt_lwin,ctrl:ralt_rctrl",
})
