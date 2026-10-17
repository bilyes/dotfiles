-----------------------------
--- ENVIRONMENT VARIABLES ---
-----------------------------

-- See https://wiki.hypr.land/configuring/core/environment-variables/
-- NOTE: hl.env only fires on launch, not on reload.

-- hl.env("XCURSOR_THEME", "McMojave-cursors")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XCURSOR_SIZE", "24")
-- hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
-- hl.env("HYPRCURSOR_SIZE", "24")

-- Dark theme for GTK-4 applications
hl.env("GTK_THEME", "Adwaita:dark")

hl.env("XDG_CONFIG_HOME", os.getenv("HOME") .. "/.config")
hl.env("XDG_CACHE_HOME", os.getenv("HOME") .. "/.cache")
hl.env("XDG_DATA_HOME", os.getenv("HOME") .. "/.local/share")
hl.env("XDG_STATE_HOME", os.getenv("HOME") .. "/.local/state")

-- NVIDIA GPU configuration
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- hl.env("GBM_BACKEND", "nvidia-drm")

-- Force NVIDIA GPU for Hyprland display rendering
-- hl.env("AQ_DRM_DEVICES", "/dev/dri/card1")

-- Hardware video acceleration
hl.env("NVD_BACKEND", "direct")

-- VRR/G-Sync
hl.env("__GL_GSYNC_ALLOWED", "1")
hl.env("__GL_VRR_ALLOWED", "1")

-- Electron apps native Wayland
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")

-- PRIME offload for running apps on NVIDIA
-- hl.env("__NV_PRIME_RENDER_OFFLOAD", "1")
-- hl.env("__VK_LAYER_NV_optimus", "NVIDIA_only")
