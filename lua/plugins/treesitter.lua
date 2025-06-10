return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		'nvim-treesitter/nvim-treesitter-textobjects'
	},
	build = function()
		require("nvim-treesitter.install").update({ with_sync = true })()
	end,
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"rust",
				"lua",
				"c",
				"cpp",
				"cmake",
				"vim",
				"vimdoc",
				"query",
				"java"
			},
			auto_install = true,
				highlight = {
					enable = true,
				},
			}
		)
		end,
	}
