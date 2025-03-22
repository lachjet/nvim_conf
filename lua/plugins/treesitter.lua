return {
	"nvim-treesitter/nvim-treesitter",
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
				"query"
			},

			auto_install = true,

			highlight = { 
				enable = true 
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<leader>ss",
					node_incremental = "<leader>si",
					scope_incremental = "<leader>sc",
					node_decremental = "<leader>sd",
				},
			},
		})
	end,

}
