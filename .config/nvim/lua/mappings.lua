-- my keybindings
local map = vim.keymap.set
local Terminal = require("toggleterm.terminal").Terminal
local utils = require("utils")
local telescope = require("telescope.builtin")
local neotree = require("neo-tree")
local bufnr = vim.api.nvim_get_current_buf()
local wk = require("which-key")

map("n", "<leader>w", ":w!<cr>", { desc = "Write Force" })
map("n", "<leader>fs", ":w!<cr>", { desc = "Write Force" })
map("n", "<leader>q", ":q!<cr>", { desc = "Quit force" })
map("n", "<leader>x", ":x!<cr>", { desc = "Write and quit force" })
map("n", "<S-l>", ":bnext<cr>", { desc = "Next Buffer" })
map("n", "<S-h>", ":bprevious<cr>", { desc = "Previous Buffer" })

-- window splitting
map("n", "<leader>v", ":vsplit<cr>", { desc = "Vertical Split" })
map("n", "<leader>wv", ":vsplit<cr>", { desc = "Vertical Split" })
map("n", "<leader>s", ":split<cr>", { desc = "Horizontal Split" })
map("n", "<leader>ws", ":split<cr>", { desc = "Horizontal Split" })

-- window navigation
map("n", "<leader>h", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<leader>wh", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<leader>j", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<leader>wj", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<leader>k", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<leader>wk", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<leader>l", "<C-w>l", { desc = "Go to Right Window", remap = true })
map("n", "<leader>wl", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- close window
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- Buffer
map("n", "<leader>bd", function(n)
	require("mini.bufremove").delete(n, false)
end, {})

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Code
wk.add({ "<leader>c", group = "Code", icon = "" })
map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
map(
	"n",
	"<leader>ct",
	'<cmd>lua require("copilot.suggestion").toggle_auto_trigger()<CR>',
	{ desc = "Toggle Copilot suggestion visibility" }
)
map("n", "<leader>cd", "<cmd>Copilot disable<CR>", { desc = "Disable copilot" })
map("n", "<leader>ce", "<cmd>Copilot enable<CR>", { desc = "Disable copilot" })
map(
	"n",
	"<leader>cc",
	'<cmd>lua require("copilot.panel").open({position,ratio})<CR>',
	{ desc = "Toggle Copilot panel visibility" }
)

-- LSP
wk.add({ "<leader>g", group = "LSP", icon = "󰘦", desc = "All keybinds available without <leader>" })
map("n", "gh", vim.lsp.buf.hover, { desc = "Show tooltip hint" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "gr", require("telescope.builtin").lsp_references, { desc = "Go to references" })
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gf", vim.lsp.buf.format, { desc = "Format code" })
map("n", "ge", vim.diagnostic.open_float, { desc = "Show diagnostics in floating window" })
-- Duplicate LSP mappings with leader key so they show up in whichkey
map("n", "<leader>gh", vim.lsp.buf.hover, { desc = "Show tooltip hint" })
map("n", "<leader>gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "<leader>gr", require("telescope.builtin").lsp_references, { desc = "Go to references" })
map("n", "<leader>gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format code" })
map("n", "<leader>ge", vim.diagnostic.open_float, { desc = "Show diagnostics in floating window" })
map("n", "<leader>gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "<leader>gs", vim.lsp.buf.signature_help, { desc = "LSP Signature Help" })
map("n", "<leader>gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })

-- telescope
wk.add({ "<leader>f", group = "Telescope", icon = "" })
map("n", "<leader><leader>", telescope.find_files, { desc = "Telescope find files" })
map("n", "<leader>fg", telescope.live_grep, { desc = "Telescope live grep" })
map("n", "<leader>fb", telescope.buffers, { desc = "Telescope buffers" })

-- Rest.nvim
wk.add({ "<leader>r", group = "Rest", icon = "" })
map("n", "<leader>rr", "<cmd>tab Rest run<CR>", { desc = "Run rest command" })
map("n", "<leader>rl", "<cmd>Rest run last<CR>", { desc = "Run last rest command" })
map("n", "<leader>ro", "<cmd>vert Rest open<CR>", { desc = "Open rest results window" })

-- Notes
wk.add({ "<leader>n", group = "Notes", icon = "󱞁" })
map("n", "<leader>ns", "<cmd>ObsidianQuickSwitch<CR>", { desc = "Quick switch notes" })
map("n", "<leader>nf", "<cmd>ObsidianSearch<CR>", { desc = "Full text search notes" })
map("n", "<leader>nt", "<cmd>ObsidianToggleCheckbox<CR>", { desc = "Toggle Checkbox" })
map("n", "<leader>nc", "<cmd>ObsidianNew<CR>", { desc = "Create new note" })

-- Neotree
map("n", "<leader>e", function()
	vim.cmd("Neotree filesystem focus")
end, { desc = "Focus left-hand file browser" })
map("n", "<C-e>", ":Neotree toggle<cr>", { desc = "Toggle Neotree" })
map("n", "<leader>fe", ":Neotree position=float<cr>", { desc = "Open Neotree" })

-- Rust
map("n", "<leader>cR", ":CargoRun<CR>", { noremap = true, silent = true, desc = "Run Cargo in Terminal" })
map(
	"n",
	"K", -- Override Neovim's built-in hover keymap with rustaceanvim's hover actions
	function()
		vim.cmd("botright split")
		vim.cmd.RustLsp({ "hover", "actions" })
	end,
	{ silent = true, buffer = bufnr, desc = "Show hover actions" }
)

-- open a floating terminal
local _floating_term = Terminal:new({
	dir = utils.find_project_root(), -- the working directory
	direction = "float", -- the direction, can be: 'vertical', 'horizontal', 'window', 'float'
	hidden = false,
	close_on_exit = false,
	float_opts = { border = "single" }, -- table: border, width, height, winblend, highlights
	on_open = function(term)
		vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
	end,
	on_close = function(term)
		vim.cmd("redraw!")
	end,
	auto_scroll = true, -- if true, the terminal will scroll on new output
})

map("n", "<leader>tt", function()
	_floating_term:toggle()
end, { desc = "Open floating terminal" })
