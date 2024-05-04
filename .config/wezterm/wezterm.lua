-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices


-- For example, changing the color scheme:
config.color_scheme = 'Lumifoo (terminal.sexy)'
config.automatically_reload_config = false
config.window_background_opacity = .8
-- and finally, return the configuration to wezterm
return config
