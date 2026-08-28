-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices.

-- For example, changing the initial geometry for new windows:
config.initial_cols = 120
config.initial_rows = 32

-- or, changing the font size and color scheme.
config.font =  wezterm.font 'JetBrains Mono'
config.font_size = 15
config.line_height = 1.15
config.cell_width = 1.0

config.color_scheme = 'Kanagawa (Gogh)'

config.window_background_opacity = 1.0

-- Finally, return the configuration to wezterm:
return config
