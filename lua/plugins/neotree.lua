local function get_last_non_neotree_win()
  local wins = vim.api.nvim_tabpage_list_wins(0)
  local current_win = vim.api.nvim_get_current_win()

  -- Iterate windows in most recently used order
  local last_non_neotree_win = nil

  -- Get window history list (most recent first)
  local win_history = vim.fn.win_findbuf(vim.api.nvim_get_current_buf())

  -- Fallback: just iterate windows normally if no history
  for _, win in ipairs(wins) do
    if win ~= current_win then
      local buf = vim.api.nvim_win_get_buf(win)
      local ft = vim.api.nvim_buf_get_option(buf, "filetype")
      if ft ~= "neo-tree" then
        last_non_neotree_win = win
        break
      end
    end
  end

  return last_non_neotree_win
end

local function open_file_split(state, split_cmd)
  local node = state.tree:get_node()
  if node and node.path then
    local selected_file = node.path

    vim.cmd("Neotree close")
    vim.cmd(split_cmd .. " " .. vim.fn.fnameescape(selected_file))

    vim.defer_fn(function()
      vim.cmd("Neotree")
    end, 50)
  else
    vim.notify("No file selected to open.", vim.log.levels.WARN)
  end
end

return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- {"3rd/image.nvim", opts = {}}, -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	lazy = false, -- neo-tree will lazily load itself
	---@module "neo-tree"
	---@type neotree.Config?
	opts = {
		event_handlers = {
			event = "neo_tree_buffer_enter",
			handler = function(args)
				vim.opt_local.number = true
				vim.opt_local.relativenumber = true
			end,
		}
	},
	config = function()
		local file_utils = require("config.file-to-application")

		-- NeoTree configuration to show hidden files
		require("neo-tree").setup({
			filesystem = {
				window = {
					mappings = {
						["<CR>"] = "open_selected",
						["<leader>p"] = "image_wezterm",
						["D"] = "diff_with_current",
						["P"] = {
							"toggle_preview",
							config = {
								use_float = false,
								-- use_image_nvim = true,
								-- title = 'Neo-tree Preview',
							},
						},
						["L"] = function(state)
							vim.cmd("set relativenumber")
						end,
					},
				},
				commands = {
					open_selected = function(state)
							local node = state.tree:get_node()
							local path = node:get_id()
							vim.opt_local.number = true
							vim.opt_local.relativenumber = true

							if node.type == "directory" then
								vim.cmd("cd " .. vim.fn.fnameescape(path))
							elseif not require("config.file-to-application").open_file(path) then
								require("neo-tree.sources.filesystem.commands").open(state)
							end
						end,
					image_wezterm = function(state)
						vim.cmd("set relativenumber")
						local node = state.tree:get_node()
						if node.type == "file" then
							require("image_preview").PreviewImage(node.path)
						end
					end,
					diff_with_current = function(state)
						vim.cmd("set relativenumber")
						local node = state.tree:get_node()
						if node and node.path then
							local selected_file = node.path

							local last_win = get_last_non_neotree_win()

							if not last_win then
								vim.notify("No suitable buffer found to diff with.", vim.log.levels.WARN)
								return
							end

							vim.cmd("Neotree close")

							-- Open selected file in vertical split (this becomes current window
							-- )
							vim.cmd("vert split " .. vim.fn.fnameescape(selected_file))
							vim.cmd("diffthis")  -- mark new split for diff

							-- Switch to last non-Neotree window
							vim.api.nvim_set_current_win(last_win)
							vim.cmd("diffthis")  -- mark last buffer window for diff

							vim.cmd("Neotree")

						else
							vim.notify("No file selected for diffing.", vim.log.levels.WARN)
						end
					end,
				},
				follow_current_file = {
					enabled = true,
				},
				use_libuv_file_watcher = true,
			},
		})
	end,
}
