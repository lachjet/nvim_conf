return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	dependencies = {
		'nvim-lua/plenary.nvim',
	},
	config = function()
		local telescope = require("telescope")

		telescope.setup({
			layout_config = {
				horizontal = { preview_cutoff = 0 },
				vertical   = { preview_cutoff = 0 },
			},
		})
	end,
}
