local Terminal = require("toggleterm.terminal").Terminal
local utils = require("utils")

function go_toggle()
    local _run_go = Terminal:new({
        cmd = "go run .", -- the command to running
        dir = utils.find_project_root(), -- the working directory
        direction = "float",     -- the direction, can be: 'vertical', 'horizontal', 'window', 'float'
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

    _run_go:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>rg", "<cmd>lua go_toggle(false)<CR>", { noremap = true, silent = true })
