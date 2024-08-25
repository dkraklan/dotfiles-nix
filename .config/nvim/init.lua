local utils = require("utils")
-- Lazy load lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

vim.g.mapleader = " "

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local projectfile = vim.fn.getcwd() .. "/project.godot"

-- Check if the project.godot file exists


if utils.file_exists(projectfile) then
    vim.fn.serverstart("./godothost")
end

require("lazy").setup("plugins")
require("options")
require("mappings")
require("ansible")
require("go")

vim.api.nvim_create_autocmd("FileType", {
    pattern = "json",
    callback = function(ev)
        -- vim.bo.formatexpr = "v:lua.vim.lsp.formatexpr()"
        vim.bo[ev.buf].formatprg = "jq"
        print("It's a json file")
    end,
})


vim.cmd.colorscheme("catppuccin")
