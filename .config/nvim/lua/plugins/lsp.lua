local plugins = {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls","ansiblels","ansible-lint" },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            local lspconfig = require("lspconfig")
            -- inlay hints
            vim.g.inlay_hints_visible = true
            local on_attach = function(client, bufnr)
                -- if client.server_capabilities.inlayHintProvider then
                --     vim.g.inlay_hints_visible = true
                --     vim.lsp.inlay_hint(bufnr, true)
                -- else
                --     print("no inlay hints available")
                -- end
            end
            -- lua
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    Lua = {
                        hint = { enable = true },
                    },
                },
            })
            lspconfig.gdscript.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
            lspconfig.ansiblels.setup({
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                    ansible = {
                        ansible = {
                            path = "ansible",
                        },
                        executionEnvironment = {
                            enabled = false,
                        },
                        python = {
                            interpreterPath = "/user/bin/python3",
                        },
                        validation = {
                            enabled = true,
                            lint = {
                                enabled = true,
                                path = "ansible-lint",
                            },
                        },
                    },
                },
            })
            vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "Show tooltip hint" })
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
            vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "Go to references" })
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.gdformat,
                },
            })
            vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { desc = "Format code" })
        end,
    },
}

return plugins
