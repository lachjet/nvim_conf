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

			-- Only for MATLAB files
			if vim.bo[bufnr].filetype == "matlab" then
				-- Floating MATLAB REPL (<Leader>re)
				buf_map(bufnr, 'n', '<Leader>re',
					'<cmd>FloatermNew! --name=MATLAB_REPL --wintype=float --autoclose=0 /usr/local/MATLAB/R2025a/bin/matlab -nodisplay -nojvm -nosplash<CR>', opts)

				-- Docked MATLAB REPL (<Leader>rd)
				buf_map(bufnr, 'n', '<Leader>rd',
					'<cmd>FloatermNew! --name=MATLAB_REPL --wintype=split --position=bottom --height=15 /usr/local/MATLAB/R2025a/bin/matlab -nodisplay -nojvm -nosplash<CR>', opts)
			end




		end

		lspconfig.clangd.setup({
			on_attach  = on_attach,
			capabilities = capbts,
			cmd = {
				'clangd',
				'--background-index',
				'--enable-config',
				'--compile-commands-dir=build',
			},
			filetypes  = { 'c', 'cpp', 'objc', 'objcpp' },
			root_dir   = lspconfig.util.root_pattern('.clangd'),
		})

		-- We want the root directory for neocmake to have BOTH a .clangd file 
		-- and a MakeLists.txt file
		local function and_root_dir(fname)
			return lspconfig.util.search_ancestors(fname, function(path)
				local has_clangd = lspconfig.util.path.is_file(lspconfig.util.path.join(path, ".clangd"))
				local has_cmake  = lspconfig.util.path.is_file(lspconfig.util.path.join(path, "CMakeLists.txt"))
				if has_clangd and has_cmake then
					return path
				end
			end)
		end

		if not lspconfig.neocmake then
			lspconfig.neocmake = {
				default_config = {
					cmd = vim.lsp.rpc.connect('127.0.0.1', '9257'),
					filetypes = { "cmake" },
					root_dir = and_root_dir,
					single_file_support = true,
					enable_external_cmake_lint = true;
					on_attach = on_attach,
					capabilities = capbts,
					init_options = {
						format = { enable = true },
					},
				},
			}
		end

		lspconfig.neocmake.setup({})

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

		-- MATLAB Language Server
		lspconfig.matlab_ls.setup({
			on_attach    = on_attach,
			capabilities = capbts,
			cmd = {
				"node",
				"/home/lachjet/MATLAB-language-server/out/index.js",
				"--stdio",
				"--matlabInstallPath=/usr/local/MATLAB/latest"
			},
			filetypes = { "matlab" },
			root_dir = lspconfig.util.root_pattern(".git", "."),
			handlers = {
				["textDocument/publishDiagnostics"] = vim.lsp.with(
					vim.lsp.diagnostic.on_publish_diagnostics, {
						virtual_text = true,  -- inline errors/warnings
						signs = true,         -- gutter signs
						underline = true,
						update_in_insert = false,
					}
				),
			}
		})



		-- Optional: customize diagnostic signs
		vim.fn.sign_define("DiagnosticSignError", {text = "✖", texthl = "DiagnosticError"})
		vim.fn.sign_define("DiagnosticSignWarn",  {text = "⚠", texthl = "DiagnosticWarn"})
		vim.fn.sign_define("DiagnosticSignInfo",  {text = "ℹ", texthl = "DiagnosticInfo"})
		vim.fn.sign_define("DiagnosticSignHint",  {text = "➤", texthl = "DiagnosticHint"})
	end,
}

