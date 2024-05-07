local plugins = {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = { "lua_ls" },
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			local lspconfig = require("lspconfig")
			-- lua
			lspconfig.lua_ls.setup({
				capabilities = capabilities,
			})

<<<<<<< HEAD
			lspconfig.gdscript.setup({
				capabilities = capabilities,
			})
=======
      lspconfig.gdscript.setup({
        capabilities = capabilities,
      })

      lspconfig.ansiblels.setup({
        capabilities = capabilities,
      })
>>>>>>> 14f2c7d (mac stuff)

			vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "Show tooltip hint" })
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
			vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.gdformat,
				},
			})
			vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format code" })
		end,
	},
}

return plugins
