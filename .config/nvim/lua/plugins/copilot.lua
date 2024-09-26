local plugins = {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        dependencies = {
            "AndreM222/copilot-lualine",
        },
        config = function()
            require("copilot").setup({
                panel = {
                    enabled = false,
                    auto_refresh = false,
                    keymap = {
                        jump_prev = "[[",
                        jump_next = "]]",
                        accept = "<CR>",
                        refresh = "gr",
                        open = "<M-CR>",
                    },
                    layout = {
                        position = "bottom", -- | top | left | right
                        ratio = 0.4,
                    },
                },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<C-p>",
                        accept_word = "<M-w>",
                        accept_line = "<C-y>",
                        next = "<M-]>",
                        pre = "<M-[>",
                        dismiss = "<C-]>",
                    },
                },
                filetypes = {
                    yaml = false,
                    ["yaml.ansible"] = true,
                    markdown = false,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    hgcommit = false,
                    svn = false,
                    cvs = false,
                    ["."] = false,
                },
                copilot_node_command = "node", -- Node.js version must be > 18.x
                server_opts_overrides = {},
            })
            vim.keymap.set("n", "<leader>ct", '<cmd>lua require("copilot.suggestion").toggle_auto_trigger()<CR>', { desc = "Toggle Copilot suggestion visibility" })
            vim.keymap.set("n", "<leader>cc", '<cmd>lua require("copilot.panel").open({position,ratio})<CR>', { desc = "Toggle Copilot panel visibility" })
        end,
    },
}

return plugins
