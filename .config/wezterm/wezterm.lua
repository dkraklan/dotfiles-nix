-- Pull in the wezterm API
local wezterm = require 'wezterm'
local keybinds = require("keybinds")

 
-- This will hold the configuration.
local config = wezterm.config_builder()
config.keys = keybinds.keys
config.key_tables = keybinds.key_tables
-- This is where you actually apply your config choices
config.automatically_reload_config = true
-- Set default dir when opening new program
config.default_cwd = "/home/dkraklan"
config.hide_tab_bar_if_only_one_tab = true



-- For example, changing the color scheme:
config.color_scheme = 'Lumifoo (terminal.sexy)'
config.window_background_opacity = .9
-- and finally, return the configuration to wezterm
return config
