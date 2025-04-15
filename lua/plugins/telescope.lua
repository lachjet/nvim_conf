return {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	-- or                              , branch = '0.1.x',
	dependencies = { 'nvim-lua/plenary.nvim' },
	extensions = {
		media_files = {
			filetypes = { "png", "jpg", "jpeg", "pdf" }, -- Enable previews for images and PDFs
			find_cmd = "rg", -- Use ripgrep for searching
		},
	}
}
