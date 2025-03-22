-- Keybindings Config (lua/config/keymaps.lua)

local map = vim.keymap.set
local nmap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Leader Key
vim.g.mapleader = " "  -- Space as leader key

-- Generic Keybindings
map("n", "<leader>/", ":noh<CR>", opts)

-- Lazy
map("n", "<leader>l", ":Lazy<CR>", opts)
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
 
-- Neotree
map("n", "<leader>nt", ":Neotree toggle=true<CR>", opts)

-- Oil
map("n", "<leader>fo", ":Oil<CR>", opts)

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)
map("n", "<leader>fg", ":Telescope live_grep<CR>", opts)


--floaterm
map("n", "<leader>td", ":FloatermNew --wintype=split --height=0.3<CR>", opts)
map("n", "<leader>tn", ":FloatermNew<CR>", opts)
map("n", "<leader>ts", ":FloatermShow<CR>", opts) 
map("t", "<C-t>k", "<C-\\><C-n>:FloatermKill<CR>", opts)
map("t", "<C-t>n", "<C-\\><C-n>:FloatermNext<CR>", opts)
map("t", "<C-t>h", "<C-\\><C-n>:FloatermHide<CR>", opts)
map("t", "<C-t>a", "<C-\\><C-n>:FloatermNew<CR>", opts)



--lazygit
map("n", "<leader>g", ":FloatermNew --title=lazygit --width=150 --height=50 <CR>lazygit<CR>", opts)
