-- Keybindings Config (lua/config/keymaps.lua)

local map = vim.keymap.set
local nmap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Leader Key
vim.g.mapleader = " "  -- Space as leader keymap

-- Functions
local function buffer_dir()
	return vim.fn.expand('%:p:h')
end

-- Generic Keybindings
map("n", "<leader>/", ":noh<CR>", opts)
map("n", "<leader>sc", ":setlocal spell spelllang=en_au<CR>", opts)
map("n", "<leader>so", ":set nospell<CR>", opts)

-- Lazy
map("n", "<leader>l", ":Lazy<CR>", opts)
-- Clipboard Copy and Paste
map("v", "<C-c>", '"+y', opts)
map({"n", "i"}, "<C-p>", '"+p', opts)
map("i", "<C-S-v>", "<C-r>+", opts)

-- Neotree
map("n", "<leader>nt", ":Neotree toggle=true<CR>", opts)
map("n", "<leader>nf", ":Neotree focus<CR>", opts)

-- Oil
map("n", "<leader>fo", ":Oil<CR>", opts)

-- Telescope
map("n", "<leader>fF", ":Telescope find_files<CR>", opts)
map("n", "<leader>fG", ":Telescope live_grep<CR>", opts)
map("n", "<leader>ff", function()
	require('telescope.builtin').find_files({ cwd = buffer_dir() })
end, opts)

map("n", "<leader>fg", function()
	require('telescope.builtin').live_grep({ cwd = buffer_dir() })
end, opts)
map("n", "<leader>ft", ":Telescope <CR>", opts)
map("n", "<leader>fm", ":Telescope media_files<CR>", opts)
map("n", "<leader>fl", ":Telescope current_buffer_fuzzy_find<CR>", opts)

-- Terminal navigation
nmap("t", "<C-w><Left>", "<C-\\><C-n><C-w>h", opts)
nmap("t", "<C-w><Down>", "<C-\\><C-n><C-w>j", opts)
nmap("t", "<C-w><Up>", "<C-\\><C-n><C-w>k", opts)
nmap("t", "<C-w><Right>", "<C-\\><C-n><C-w>l", opts)
nmap("t", "<C-w>h", "<C-\\><C-n><C-w>h", opts)
nmap("t", "<C-w>j", "<C-\\><C-n><C-w>j", opts)
nmap("t", "<C-w>k", "<C-\\><C-n><C-w>k", opts)
nmap("t", "<C-w>l", "<C-\\><C-n><C-w>l", opts)
nmap("t", "<C-w>/", "<C-\\><C-n>", opts)
nmap("t", "<C-t>/", "<C-\\><C-n>", opts)

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

-- Diffview bindings
map("n", "<leader>do", "<cmd>DiffviewOpen<CR>", { desc = "Diffview: Open" })
map("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { desc = "Diffview: Close" })
map("n", "<leader>df", "<cmd>DiffviewFileHistory<CR>", { desc = "Diffview: File History" })
map("n", "<leader>dr", "<cmd>DiffviewRefresh<CR>", { desc = "Diffview: Refresh" })

-- diff off
map("n", "<leader>dx", ":windo diffoff<CR>", { desc = "Turn off diff mode" })


M = {}
M.HandleURL = function()
  local url = string.match(vim.fn.getline("."), "[a-z]+://[^%s%]%}%)\"'>,;]+")
  if url ~= "" then
    vim.cmd('exec "!open \'' .. url .. '\'"')
  else
    vim.cmd('echo "No URI found in line."')
  end
end

vim.api.nvim_set_keymap("n", "<leader>x", [[ <Cmd>lua M.HandleURL()<CR> ]], {})
