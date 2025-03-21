-- Keybindings Config (lua/config/keymaps.lua)

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader Key
vim.g.mapleader = " "  -- Space as leader key

-- Generic Keybindings
map("n", "<leader>/", ":noh<CR>", opts) 

-- Which-Key
map("n", "<leader>z", ":WhichKey <leader><CR>", opts)

-- Neotree
map("n", "<leader>t", ":Neotree toggle=true<CR>", opts)

-- Oil
map("n", "<leader>o", ":Oil<CR>", opts)

-- Telescope
map("n", "<leader>f", ":Telescope find_files<CR>", opts)
map("n", "<leader>g", ":Telescope live_grep<CR>", opts)


--floaterm
map("n", "<leader>x", ":FloatermNew<CR>", opts)
