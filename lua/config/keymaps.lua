-- Keybindings Config (lua/config/keymaps.lua)

local map = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Leader Key
vim.g.mapleader = " "  -- Space as leader key

-- Generic Keybindings
map("n", "<leader>/", ":noh<CR>", opts)

-- Terminal navigation
vim.api.nvim_set_keymap("t", "<C-w><Left>", "<C-\\><C-n><C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-w><Down>", "<C-\\><C-n><C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-w><Up>", "<C-\\><C-n><C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-w><Right>", "<C-\\><C-n><C-w>l", { noremap = true, silent = true })
vim.api.nvim_set_keymap("t", "<C-w>/", "<C-\\><C-n>", { noremap = true, silent = true })

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
map("n", "<leader>x", ":FloatermNew --wintype=split --height=0.3<CR>", opts)
