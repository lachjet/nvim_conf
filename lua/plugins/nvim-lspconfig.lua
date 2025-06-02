return {
	'neovim/nvim-lspconfig',
	dependencies = {
		{ 'hrsh7th/nvim-cmp', opts = {} },
	},
	config = function()
		local lspconfig = require('lspconfig')
		local capbts   = require('cmp_nvim_lsp').default_capabilities()

		-- Optional: configure how diagnostics are displayed
		vim.diagnostic.config({
			virtual_text     = false,
			signs            = true,
			underline        = true,
			update_in_insert = false,
			severity_sort    = false,
		})

		-- on_attach maps keys once an LSP server is attached to a buffer
		local on_attach = function(client, bufnr)
			local buf_map = vim.api.nvim_buf_set_keymap
			local opts    = { noremap = true, silent = true }

			-- Hover (view type/signature/docs) with K
			buf_map(bufnr, 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)

			-- Jump to definition with gd
			buf_map(bufnr, 'n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)

			-- Open code action menu
			buf_map(bufnr, 'n', "<Leader>c", "<cmd>lua vim.lsp.buf.code_action({apply = false})<CR>", opts)

			-- Navigate diagnostics
			-- Navigate diagnostics
			buf_map(bufnr, "n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
			buf_map(bufnr, "n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)

			-- Only show diagnostics when <Leader>e is pressed
			buf_map(
				bufnr,
				'n',
				'<Leader>e',
				'<cmd>lua vim.diagnostic.open_float(nil, { focus = false })<CR>',
				opts
			)

			-- Navigate between diagnostics (they’re still “in the background”)
			buf_map(bufnr, 'n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
			buf_map(bufnr, 'n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
		end
		-- clangd setup: points at your compile_commands.json or compile_flags.txt
		lspconfig.clangd.setup({
			on_attach  = on_attach,
			capabilities = capbts,
			cmd        = { 'clangd', '--background-index' },
			filetypes  = { 'c', 'cpp', 'objc', 'objcpp' },
			root_dir   = lspconfig.util.root_pattern('compile_commands.json', 'compile_flags.txt', '.git'),
		})

		-- Lua language server
		lspconfig.lua_ls.setup({
			on_attach    = on_attach,
			capabilities = capbts,
		})

		-- LaTeX language server
		lspconfig.texlab.setup({
			on_attach    = on_attach,
			capabilities = capbts,
    })
  end,
}

