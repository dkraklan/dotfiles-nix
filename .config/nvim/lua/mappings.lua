-- my keybindings
local map = vim.keymap.set

map("n", "<leader>w", ":w!<cr>", { desc = "Write Force" })
map("n", "<leader>q", ":q!<cr>", { desc = "Quit force" })
map("n", "<leader>x", ":x!<cr>", { desc = "Write and quit force" })
map("n", "<S-l>", ":bnext<cr>", { desc = "Next Buffer" })
map("n", "<S-h>", ":bprevious<cr>", { desc = "Previous Buffer" })

-- window splitting
map("n", "<leader>v", ":vsplit<cr>", { desc = "Vertical Split" })
map("n", "<leader>s", ":split<cr>", { desc = "Horizontal Split" })

-- window navigation
map("n", "<leader>h", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<leader>j", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<leader>k", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<leader>l", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- close window
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
map('n', 'ge', vim.diagnostic.open_float, {desc = "Show diagnostics in floating window"})
