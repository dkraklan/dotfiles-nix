local cargo_term_buf = nil
local cargo_term_win = nil

vim.api.nvim_create_user_command('CargoRun', function()
    local current_win = vim.api.nvim_get_current_win()
    local current_file = vim.api.nvim_buf_get_name(0)
    local cwd = vim.fn.fnamemodify(current_file, ':h')
    
    if cargo_term_buf and vim.api.nvim_buf_is_valid(cargo_term_buf) then
        if cargo_term_win and vim.api.nvim_win_is_valid(cargo_term_win) then
            vim.api.nvim_set_current_win(cargo_term_win)
        else
            vim.cmd('botright 15split')
            cargo_term_win = vim.api.nvim_get_current_win()
            vim.api.nvim_win_set_buf(cargo_term_win, cargo_term_buf)
        end
        vim.api.nvim_chan_send(vim.b.terminal_job_id, string.format("\x0ccd %s && cargo run\n", cwd))
    else
        vim.cmd('botright 15split')
        cargo_term_win = vim.api.nvim_get_current_win()
        -- Set environment variable before creating terminal
        vim.fn.setenv('SKIP_FASTFETCH', '1')
        vim.cmd('terminal')
        -- Optionally unset it after terminal is created
        vim.fn.setenv('SKIP_FASTFETCH', nil)
        cargo_term_buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_chan_send(vim.b.terminal_job_id, string.format("cd %s && cargo run\n", cwd))
    end
    
    vim.api.nvim_set_current_win(current_win)
end, {})
