local plugins = {
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		opts = {},
		config = function()
			require("catppuccin").setup({
				transparent_background = true,
				integrations = {
					cmp = true,
					dashboard = true,
					mason = true,
					native_lsp = {
						enabled = true,
						underlines = {
							errors = { "undercurl" },
							hints = { "undercurl" },
							warnings = { "undercurl" },
							information = { "undercurl" },
						},
					},
					neotree = true,
					noice = true,
					notify = true,
					telescope = true,
					treesitter = true,
					treesitter_context = true,
					which_key = true,
				},
			})
		end,

	},
}

return plugins
