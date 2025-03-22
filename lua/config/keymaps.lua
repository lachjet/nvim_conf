-- Keybindings Config (lua/config/keymaps.lua)

local map = vim.keymap.set
local nmap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Leader Key
vim.g.mapleader = " "  -- Space as leader key

-- Generic Keybindings
map("n", "<leader>/", ":noh<CR>", opts)

-- Clipboard Copy and Paste
map("v", "<C-c>", '"+y', opts)
map({"n", "i"}, "<C-p>", '"+p', opts)
map("i", "<C-S-v>", "<C-r>+", opts)

-- Terminal navigation
nmap("t", "<C-w><Left>", "<C-\\><C-n><C-w>h", opts)
nmap("t", "<C-w><Down>", "<C-\\><C-n><C-w>j", opts)
nmap("t", "<C-w><Up>", "<C-\\><C-n><C-w>k", opts)
nmap("t", "<C-w><Right>", "<C-\\><C-n><C-w>l", opts)
nmap("t", "<C-w>/", "<C-\\><C-n>", opts)

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
map("n", "<leader>x", ":FloatermNew --wintype=split --height=1.3<CR>", opts)
map("n", "<leader>a", ":FloatermNew<CR>", opts)

--lazygit
map("n", "<leader>m", ":FloatermNew<CR>lazygit<CR>", opts)
