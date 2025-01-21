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
                    "docker-compose-language-service",
                    "isort",
                    "djlint",
                    "isort",
                    "black",
                    "eslint",
                    "prettier",
                    "shellcheck",
                    "shellharden"
                },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "ansiblels",
                    "rust_analyzer",
                    "gopls",
                    "golangci_lint_ls",
                    "jsonls",
                    "pyright",
                    "docker_compose_language_service",
                    -- "jinja_lsp",
                    "volar",
                    -- "tsserver",
                    "bashls",
                },
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

            --- Golang
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

            --- Golang lint
            lspconfig.golangci_lint_ls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
            })


            --- Python
            lspconfig.pyright.setup({})

            --- Json
            lspconfig.jsonls.setup({})

            -- Docker compose
            lspconfig.docker_compose_language_service.setup({})

            -- Jinja
            lspconfig.jinja_lsp.setup({})

            -- Bash
            lspconfig.bashls.setup({})

                    end,
    },
    {
        "nvimtools/none-ls.nvim",
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    -- I have these commented out becuase of a super annoying issue with none-LS at the moment
                    -- https://github.com/nvimtools/none-ls.nvim/issues/241
                    -- null_ls.builtins.formatting.stylua,
                    --
                    null_ls.builtins.formatting.gdformat,
                    -- null_ls.builtins.formatting.black,
                    -- null_ls.builtins.formatting.isort,
                    null_ls.builtins.formatting.djlint,
                    -- null_ls.builtins.formatting.prettier,
                },
                -- This function will prevent null-ls from attaching to vue files
                on_attach = function(client, bufnr)
                    local filetype = vim.api.nvim_buf_get_option(bufnr, "filetype")
                    if filetype == "vue" then
                        client.stop() -- Stop null-ls from attaching to Vue files
                    end
                end,
            })
       end,
    },
    -- {
    --     "stevearc/conform.nvim",
    --     opts = {},
    -- },
}

return plugins
