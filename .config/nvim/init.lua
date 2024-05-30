vim.g.mapleader = " "

-- Lazy load lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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
local function file_exists(path)
    local stat = vim.loop.fs_stat(path)
    return stat and stat.type == 'file'
end

if file_exists(projectfile) then
    vim.fn.serverstart("./godothost")
end

require("lazy").setup("plugins")
require("options")
require("mappings")
require("ansible")
require("go")



vim.cmd.colorscheme("catppuccin")
