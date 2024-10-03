-- my keybindings
local map = vim.keymap.set
local Terminal = require("toggleterm.terminal").Terminal
local utils = require("utils")
local telescope = require("telescope.builtin")

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
map("n", "ge", vim.diagnostic.open_float, { desc = "Show diagnostics in floating window" })

-- telescope
map("n", "<leader><leader>", telescope.find_files, { desc = 'Telescope find files'})
map("n", "<leader>fg", telescope.live_grep, { desc = 'Telescope live grep'})
map('n', '<leader>fb', telescope.buffers, { desc = 'Telescope buffers' })

-- Rest.nvim
map("n", "<leader>rr", "<cmd>tab Rest run<CR>", { desc = "Run rest command" })
map("n", "<leader>rl", "<cmd>Rest run last<CR>", { desc = "Run last rest command" })
map("n", "<leader>ro", "<cmd>vert Rest open<CR>", { desc = "Open rest results window" })

-- open a floating terminal
local _floating_term = Terminal:new({
    dir = utils.find_project_root(), -- the working directory
    direction = "float",          -- the direction, can be: 'vertical', 'horizontal', 'window', 'float'
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

map("n", "<leader>tt", function() _floating_term:toggle() end, { desc = "Open floating terminal" })
