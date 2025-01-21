plugins = {
	{
		"mrcjkb/rustaceanvim",
		version = "^5", -- Recommended
		lazy = false, -- This plugin is already lazy
		config = function()
			vim.keymap.set("n", "<leader>rf", function()
				vim.cmd.RustLsp("run")
			end, { noremap = true, silent = true, desc = "Run Rust Program" })
			vim.g.rustaceanvim = {
				-- LSP configuration
				server = {
					default_settings = {
						-- rust-analyzer language server configuration
						["rust-analyzer"] = {
							inlayHints = {
								lifetimeElisionHints = {
									enable = true,
									useParameterNames = true,
								},
							},
						},
					},
				},
			}
		end,
	},
}

return plugins
