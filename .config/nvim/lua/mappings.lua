-- my keybindings
local map = vim.keymap.set

map("n", "<leader>w", ":w!<cr>", { desc = "Write Force" })
map("n", "<leader>q", ":q!<cr>", { desc = "Quit force" })
map("n", "<leader>x", ":x!<cr>", { desc = "Write and quit force" })
map("n", "<S-l>", ":bnext<cr>", { desc = "Next Buffer" })
map("n", "<S-h>", ":bprevious<cr>", { desc = "Previous Buffer" })
map("n", "<leader>v", ":vsplit<cr>", { desc = "Vertical Split" })
map("n", "<leader>s", ":split<cr>", { desc = "Horizontal Split" })
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })
