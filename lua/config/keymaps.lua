-- Keybindings Config (lua/config/keymaps.lua)

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader Key
vim.g.mapleader = " "  -- Space as leader key

-- Generic Keybindings
map("n", "<leader>/", ":noh<CR>", opts) 

-- Neotree
map("n", "<leader>tt", ":Neotree toggle=true<CR>", opts)
map("n", "<leader>th", ":Neotree<CR>", opts)
map("n", "<leader>ty", ":Neotree close<CR>", opts)
map("n", "<leader>tr", function()
	vim.cmd("Neotree reveal")
	vim.cmd("Neotree dir=..")
end, opts)
map("n", "<leader>tf", ":Neotree dir=", opts)
