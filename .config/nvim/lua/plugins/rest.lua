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
        config = function()
            require("rest-nvim").setup({
                env = {
                    pattern = "%.env$",
                },
                response = {
                    hooks = {
                        decode_url = true,
                        format = true,
                    },
                },
                ui = {
                    -- winbar = true,
                    keybinds = {
                        prev = "P",
                        next = "N",
                    },
                },
            })
        end,
    },
}

return plugins
