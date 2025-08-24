-- Keybindings Config (lua/config/keymaps.lua)

local map = vim.keymap.set
local nmap = map
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

-- Alpha
map("n", "<leader>m", ":Alpha<CR>", {desc = "Menu"})

-- Neotree
map("n", "<leader>nt", ":Neotree toggle left<CR>:set relativenumber<CR>", opts)
map("n", "<leader>nf", ":Neotree focus<CR>:set relativenumber<CR>", opts)
map("n", "<leader>ne", ":Neotree toggle float<CR>:set relativenumber<CR>", { desc = "Floating File Explorer" })

-- Oil
map("n", "<leader>fo", ":Oil<CR>", opts)

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)
map("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
map("n", "<leader>fF", function()
	require('telescope.builtin').find_files({ cwd = buffer_dir() })
end, opts)
map("n", "<leader>fo", ":Telescope old_files<CR>", opts);

map("n", "<leader>fG", function()
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
map("t", "<C-t>b", "<C-\\><C-n>:FloatermPrev<CR>", opts)
map("t", "<C-t>h", "<C-\\><C-n>:FloatermHide<CR>", opts)
map("t", "<C-t>a", "<C-\\><C-n>:FloatermNew<CR>", opts)

--lazygit
map("n", "<leader>g", ":FloatermNew --title=lazygit --width=150 --height=50 bash -c 'lazygit'; exit<CR>", opts)


--buffer navigation
map("n", "<leader>b", ":b#<CR>", opts)

-- nvim current dir
vim.api.nvim_create_user_command("CDToFile", function()
  local file = vim.api.nvim_buf_get_name(0)
  if file == "" then
    print("No file loaded.")
    return
  end
  local dir = vim.fn.fnamemodify(file, ":p:h")
  vim.cmd("cd " .. dir)
  print("Changed directory to: " .. dir)
end, {})


vim.api.nvim_create_user_command("CDToProjectRoot", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_active_clients({bufnr = bufnr})
  local client = clients[1]

  if not client then
    print("No active LSP client found for this buffer.")
    return
  end

  local root_dir = client.config.root_dir
  if not root_dir then
    print("LSP client has no root directory.")
    return
  end

  vim.cmd("cd " .. root_dir)
  print("Changed directory to LSP root: " .. root_dir)
end, {})

map("n", "<leader>cdf", "<cmd>CDToFile<CR>", {desc = "cd to current file's directory"})
map("n", "<leader>cdh", ":cd ~<CR>", {desc = "cd to home directory"})
map("n", "<leader>cdm", ":cd /<CR>", {desc = "cd to mount point"})
map("n", "<leader>cdp", "<cmd>CDToProjectRoot<CR>", { desc = "cd to project root directory" })

-- Diffview bindings
map("n", "<leader>do", "<cmd>DiffviewOpen<CR>", { desc = "Diffview: Open" })
map("n", "<leader>dc", "<cmd>DiffviewClose<CR>", { desc = "Diffview: Close" })
map("n", "<leader>df", "<cmd>DiffviewFileHistory<CR>", { desc = "Diffview: File History" })
map("n", "<leader>dr", "<cmd>DiffviewRefresh<CR>", { desc = "Diffview: Refresh" })

-- diff off
map("n", "<leader>dx", ":windo diffoff<CR>", { desc = "Turn off diff mode" })

-- Tab Actions under <leader>tt
map("n", "<leader>ttn", ":tabnew<CR>", { desc = "New Tab" })         -- New Tab
map("n", "<leader>ttc", ":tabclose<CR>", { desc = "Close Tab" })     -- Close Tab
map("n", "<leader>tto", ":tabonly<CR>", { desc = "Close Other Tabs" }) -- Close all other tabs
map("n", "<leader>ttl", ":tabnext<CR>", { desc = "Next Tab" })       -- Tab → Next
map("n", "<leader>tth", ":tabprevious<CR>", { desc = "Previous Tab" }) -- Tab → Prev
for i = 1, 9 do
  map("n", "<leader>tt" .. i, ":tabnext " .. i .. "<CR>", { desc = "Go to Tab " .. i })
end

-- General Quality of life keybindings
map("n", "<leader>q", ":q<CR>", {desc = "Quit the current buffer"})
map("n", "<leader>Q", ":q!<CR>", {desc = "Quit the current buffer"})
map("n", "<leader>w", ":w<CR>", {desc = "Quit the current buffer"})
map("i", "jj", "<ESC>", { desc = "Exit Insert mode with jk" })
map("v", "fp", "<ESC>", { desc = "Exit Visual mode with jk" })
map("n", "<leader>ef", ":echo @%<CR>", { desc = "Echo the current path" })
map("n", "<leader>h", "<C-w>h", { desc = "Jump to next window left" })
map("n", "<leader>j", "<C-w>j", { desc = "Jump to next window up" })
map("n", "<leader>k", "<C-w>k", { desc = "Jump to next window down" })
map("n", "<leader>l", "<C-w>l", { desc = "Jump to next window right" })
map("n", "<leader>v", "<C-w>v", { desc = "Jump to next window right" })
map("n", "<leader>s", "<C-w>s", { desc = "Jump to next window right" })
map("n", "<leader>y", "let @+ = @\"<CR>", { desc = "Yank Register to System Clipboard" })
map("n", "<leader>Y", "let @\" = @+<CR>", { desc = "System Clipboard to Yank Register" })
map("n", "<leader>r", ":later<CR>", { desc = "Jump to next window right" })
M = {}
M.HandleURL = function()
  local url = string.match(vim.fn.getline("."), "[a-z]+://[^%s%]%}%)\"'>,;]+")
  if url ~= "" then
    vim.cmd('exec "!open \'' .. url .. '\'"')
  else
    vim.cmd('echo "No URI found in line."')
  end
end

map("n", "<leader>x", [[ <Cmd>lua M.HandleURL()<CR> ]], {})
