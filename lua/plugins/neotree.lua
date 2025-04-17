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
		-- fill any relevant options here
	},
	config = function()
		local file_utils = require("config.file-to-application")

		-- NeoTree configuration to show hidden files
		require("neo-tree").setup({
			filesystem = {
				filtered_items = {
					visible = true,          -- Show filtered files
					hide_dotfiles = false,   -- Don't hide dotfiles
					hide_gitignore = false,  -- Optionally disable hiding files listed in .gitignore
				},
				window = {
					mappings = {
						["<CR>"] = function(state)
							local node = state.tree:get_node()
							local path = node:get_id()
							if not file_utils.open_file(path) then
								require("neo-tree.sources.filesystem.commands").open(state)
							end
						end,
						["<leader>p"] = "image_wezterm",
					},
				},
				commands = {
					image_wezterm = function(state)
						local node = state.tree:get_node()
						if node.type == "file" then
							require("image_preview").PreviewImage(node.path)
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
