return {
	"nvim-treesitter/nvim-treesitter",
	build = function()
		require("nvim-treesitter.install").update({ with_sync = true })()
	end,
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"lua", "vim", "vimdoc", "query",
				"python",
				"javascript", "typescript",
				"html", "css",
				"json", "yaml", "markdown",
			},
			auto_install = true,
			highlight = { enable = true },
			indent    = { enable = true },
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection    = "gnn",
					node_incremental  = "grn",
					scope_incremental = "grs",
					node_decremental  = "grm",
				},
			},
		})
		vim.api.nvim_set_hl(0, "@comment", { fg = "#00CC00", italic = true })
	end,
}
