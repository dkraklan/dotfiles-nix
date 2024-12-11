-- lua/custom/terminal.lua

local Terminal = require("toggleterm.terminal").Terminal

-- Create a new terminal instance for lazydocker
local lazydocker = Terminal:new({
  cmd = "lazydocker",        -- The command to run in the terminal
  direction = "float",       -- Open in a floating window
  hidden = true,             -- Keep the terminal hidden until toggle is called
  on_open = function(term)
    -- Set initial window height and animation (assuming animate.nvim or similar)
    vim.api.nvim_win_set_height(term.window, 1)  -- Start with small height

    -- Use camspiers/animate.nvim to animate window height
    if vim.fn.exists(':Animate') == 2 then
      vim.fn['animate#window_percent_height'](0.66)
    else
      -- If no animation plugin is found, just resize directly
      vim.cmd('resize 66')
    end

    -- Start in insert mode
    vim.cmd("startinsert!")
  end,
})

-- Function to toggle the lazydocker terminal
function toggle_lazydocker()
  lazydocker:toggle()
end

-- Key mapping to toggle lazydocker with <leader>d
vim.api.nvim_set_keymap("n", "<leader>d", "<cmd>lua toggle_lazydocker()<CR>", { noremap = true, silent = true })
