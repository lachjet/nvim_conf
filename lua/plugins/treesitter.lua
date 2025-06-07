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
					enable = true
				},

				textobjects = {
					move = {
						enable = true,
						set_jumps = true,

						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
							["]s"] = { query = "@local.scope", query_group = "locals", desc = "Next scope" },
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]C"] = "@class.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
							["[s"] = { query = "@local.scope", query_group = "locals", desc = "Prev scope" },
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[C"] = "@class.outer",
						},
					},

					select = {
						enable = true,
						lookahead = true,	
						},
						selection_modes = {
							['@function.outer'] = 'V',
							['@class.outer'] = 'V',
							['@local.scope'] = 'V',
						},
						include_surrounding_whitespace = true,
					},
				}
			)
		end,
	}
