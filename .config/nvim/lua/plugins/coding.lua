local plugins = {
    { "echasnovski/mini.comment", version = "*" },
    {
        "f-person/git-blame.nvim",
        config = function()
            require("gitblame").setup({
                enabled = true,
                message_template = "<summary> • <date>",
                message_when_not_committed = "uncommited !",
                virtual_text_column = 80,
            })
        end,
    },
}

return plugins
