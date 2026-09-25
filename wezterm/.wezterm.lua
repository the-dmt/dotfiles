-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.term = "xterm-256color"

-- For example, changing the initial geometry for new windows:
config.initial_cols = 100
config.initial_rows = 25

config.window_decorations = "NONE"

config.color_scheme = 'Tokyo Night'

config.font =  wezterm.font 'JetBrains Mono'
config.font_size = 15
config.line_height = 1.2
config.cell_width = 1.0

config.animation_fps = 1
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.hide_mouse_cursor_when_typing = true

config.enable_scroll_bar = false
config.enable_tab_bar = false
hide_tab_bar_if_only_one_tab = true
config.scrollback_lines = 10000

config.quote_dropped_files = "Posix"

config.exit_behavior_messaging = "None"

config.audible_bell = "Disabled"

config.clean_exit_codes = { 130 }

config.window_close_confirmation = 'NeverPrompt'

config.automatically_reload_config = true

-- Finally, return the configuration to wezterm:
return config
