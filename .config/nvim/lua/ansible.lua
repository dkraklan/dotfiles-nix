local Terminal = require("toggleterm.terminal").Terminal
local utils = require("utils")

local function extract_playbook_name()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    -- Check if the current buffer tells us the playbook name
    for _, line in ipairs(lines) do
        local match = line:match("# @playbook: (.+%.yml)")
        if match then
            return match
        end
    end
    local cwd = vim.fn.getcwd() -- Get the directory of the current buffers
    local project_root = utils.find_project_root()
    -- if the current buffer is in the root directory of the project, we can assume the file is a playbook
    if project_root == cwd then
        return vim.fn.expand("%:t")

    end

    return nil
end

local function check_become_pass()
    -- Check for presence of "hosts:" and "become:"
    local bufnr = vim.api.nvim_get_current_buf()
    local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false) -- Get all lines
    local found_hosts, found_become = false, false
    for _, line in ipairs(content) do
        if string.find(line, "hosts: localhost") then
            found_hosts = true
        end
        if string.find(line, "become: true") then
            found_become = true
        end
        -- our own decorator, generally used inside tasks so we can run playbooks from tasks as well
        if string.find(line, "@ask_become_pass: true") then
            return "--ask-become-pass "
        end
    end
    if found_hosts and found_become then
        return "--ask-become-pass "
    end
    return ""
end

local function is_localhost_playbook()
    local bufnr = vim.api.nvim_get_current_buf()
    local content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false) -- Get all lines
    for _, line in ipairs(content) do
        if string.find(line, "hosts: localhost") then
            return true
        end
    end
    return false
end

local function is_poetry_env()
    local project_root = utils.find_project_root()
    local pyproject_toml = project_root .. "/pyproject.toml"
    if utils.file_exists(pyproject_toml) then
        return true
    end
    return false
end


local function build_ansible_command(check)
    local project_root = utils.find_project_root() -- Get the root directory of the projectfile
    local inventory_file = "lab"
    local playbook_name = extract_playbook_name()
    local command_table = {}
    if not playbook_name then
        return
    end
    if is_localhost_playbook() then
        table.insert(command_table, "ANSIBLE_CONFIG=ansible_localhost.cfg ")
    end
    if is_poetry_env() then
        table.insert(command_table, "poetry run ansible-playbook ")
    else
        table.insert(command_table, "ansible-playbook ")
    end
    table.insert(command_table, playbook_name .. " ")
    table.insert(command_table, "-i ")
    table.insert(command_table, inventory_file .. " ")
    table.insert(command_table, check_become_pass())
    table.insert(command_table, "--diff ")
    if check then
        table.insert(command_table, "--check ")
    end
    local command = table.concat(command_table)
    return command
end

function _ansible_toggle()
    local _ansible_playbook = Terminal:new({
        cmd = build_ansible_command(), -- the command to running
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

    _ansible_playbook:toggle()
end

vim.api.nvim_set_keymap("n", "<leader>rp", "<cmd>lua _ansible_toggle(false)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>rc", "<cmd>lua _ansible_toggle(true)<CR>", { noremap = true, silent = true })
