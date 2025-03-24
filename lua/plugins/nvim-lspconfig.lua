return {
	'neovim/nvim-lspconfig',
	dependencies = {
		{ { 'hrsh7th/nvim-cmp', opts = {} } }
	},
	config = function()
		local lspconfig = require('lspconfig')
		local capbts = require('cmp_nvim_lsp').default_capabilities()

		lspconfig.clangd.setup({
			capabilities = capbts;
		})
		lspconfig.lua_ls.setup({
			capabilities = capbts;
		})
	end,
}



