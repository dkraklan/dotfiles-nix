local plugins = {
    -- "diepm/vim-rest-console",
    {
        "vhyrro/luarocks.nvim",
        priority = 1000,
        config = true,
        opts = {
            rocks = { "lua-curl", "nvim-nio", "mimetypes", "xml2lua" },
        },
    },
    {
        "rest-nvim/rest.nvim",
        ft = "http",
        dependencies = { "luarocks.nvim" },
        -- config = function()
        --     require("rest-nvim").setup({
        opts = {
            client = "curl",
            env_file = ".env",
            env_pattern = "\\.env$",
            env_edit_command = "tabedit",
            encode_url = true,
            skip_ssl_verification = false,
            custom_dynamic_variables = {},
            logs = {
                level = "info",
                save = true,
            },
            result = {
                split = {
                    horizontal = false,
                    in_place = true,
                    stay_in_current_window_after_split = true,
                },
                behavior = {
                    decode_url = true,
                    show_info = {
                        url = true,
                        headers = true,
                        http_info = true,
                        curl_command = true,
                    },
                    statistics = {
                        enable = true,
                        stats = {
                            { "total_time",      title = "Time taken:" },
                            { "size_download_t", title = "Download size:" },
                        },
                    },
                    formatters = {
                        json = "jq",
                        html = function(body)
                            if vim.fn.executable("tidy") == 0 then
                                return body, { found = false, name = "tidy" }
                            end
                            local fmt_body = vim.fn
                                .system({
                                    "tidy",
                                    "-i",
                                    "-q",
                                    "--tidy-mark",
                                    "no",
                                    "--show-body-only",
                                    "auto",
                                    "--show-errors",
                                    "0",
                                    "--show-warnings",
                                    "0",
                                    "-",
                                }, body)
                                :gsub("\n$", "")

                            return fmt_body, { found = true, name = "tidy" }
                        end,
                    },
                },
                keybinds = {
                    buffer_local = true,
                    prev = "P",
                    next = "N",
                },
            },
            highlight = {
                enable = true,
                timeout = 750,
            },
        },
        -- })
        --     vim.keymap.set("n", "<leader>rr", "<cmd>Rest run<CR>", { desc = "Run rest command" })
        --     vim.keymap.set("n", "<leader>rl", "<cmd>Rest run last<CR>", { desc = "Run last rest command" })
        -- end,
    },
}

return plugins
