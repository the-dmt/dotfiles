-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.term = "xterm-256color"

-- For example, changing the initial geometry for new windows:
config.initial_cols = 100
config.initial_rows = 25

-- config.window_padding = {
--   left = 20,
--   right = 20,
--   top = 20,
--   bottom = 20,
-- }
--
config.color_scheme = 'Kanagawa (Gogh)'

config.font =  wezterm.font 'JetBrains Mono'
config.font_size = 15
config.line_height = 1.2
config.cell_width = 1.0

-- config.window_background_opacity = 0.9
-- config.macos_window_background_blur = 20
-- config.wayland_window_background_blur = true

-- config.native_macos_fullscreen_mode = false

config.animation_fps = 1
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

config.enable_scroll_bar = false
config.enable_tab_bar = false
config.scrollback_lines = 10000

config.exit_behavior_messaging = "None"

config.audible_bell = "Disabled"

config.clean_exit_codes = { 130 }

config.window_close_confirmation = 'NeverPrompt'

config.automatically_reload_config = true

-- Finally, return the configuration to wezterm:
return config
