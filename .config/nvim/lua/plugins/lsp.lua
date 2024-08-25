local util = require("utils")

local plugins = {

    {
        "folke/neodev.nvim",
        opts = {},
        config = function()
            require("neodev").setup({
                -- add any options here, or leave empty to use the default settings
            })
        end,
    },
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ensure_installed = {
                    "gopls",
                },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "ansiblels", "rust_analyzer", "gopls", "golangci_lint_ls","jsonls" },
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
                if client.server_capabilities.inlayHintProvider then
                    vim.g.inlay_hints_visible = true
                    vim.lsp.inlay_hint.enable()
                else
                    print("no inlay hints available")
                end
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
            -- gdscript
            lspconfig.gdscript.setup({
                capabilities = capabilities,
                on_attach = on_attach,
            })
            -- ansible
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
            lspconfig.gopls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                cmd = { "gopls" },
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                -- root_dir = util.find_project_root(),
                settings = {
                    gopls = {
                        completeUnimported = true,
                        usePlaceholders = true,
                        analyses = {
                            unusedparams = true,
                        },
                    },
                },
            })
            lspconfig.golangci_lint_ls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })
            require'lspconfig'.jsonls.setup{}
            vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "Show tooltip hint" })
            vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
            vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
            vim.keymap.set("n", "gr", require("telescope.builtin").lsp_references, { desc = "Go to references" })
            vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
            -- vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
            -- vim.keymap.set("n", "gs", vim.lsp.buf.signature_help, { desc = "Show signature help" })
            -- vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
            -- vim.keymap.set("n", "gh", vim.lsp.buf.hover, { desc = "Show tooltip hint" })
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
    -- {
    --     "stevearc/conform.nvim",
    --     opts = {},
    -- },
}

return plugins
