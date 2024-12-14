local plugins = {
	-- "diepm/vim-rest-console",
	{
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
		opts = {
			rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
		},
	},
	{
		"rest-nvim/rest.nvim",
		ft = "http",
		dependencies = { "luarocks.nvim" },
		config = function()
			require("rest-nvim").setup({
				env = {
					pattern = "%.env$",
				},
				response = {
					hooks = {
						decode_url = true,
						format = true,
					},
				},
				ui = {
					-- winbar = true,
					keybinds = {
						prev = "P",
						next = "N",
					},
				},
			})
		end,
	},
}

-- We don't want to use thse plugins if we're on a macbook, shit just dont work

local is_macos = vim.loop.os_uname().sysname == "Darwin"
if is_macos then
	return {}
else
	return plugins
end
