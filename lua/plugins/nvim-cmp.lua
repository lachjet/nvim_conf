return {
	{
		'hrsh7th/nvim-cmp',
		event = "InsertEnter",
		dependencies = {
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
			'hrsh7th/cmp-cmdline',
			'hrsh7th/vim-vsnip',
			'hrsh7th/cmp-vsnip',
			'f3fora/cmp-spell', -- spell completion source
			-- Note: removed 'hrsh7th/cmp-buffer' from global deps so buffer is not auto-used everywhere.
		},
		config = function()
			local cmp = require('cmp')

			-- Global default: no 'buffer' source here
			cmp.setup({
				snippet = {
					expand = function(args)
						vim.fn["vsnip#anonymous"](args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<CR>'] = cmp.mapping.confirm({ select = true }),
					['<Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						else
							fallback()
						end
					end, { 'i', 's' }),
					['<S-Tab>'] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						else
							fallback()
						end
					end, { 'i', 's' }),
				}),
				-- keep language server + snippets by default only
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					{ name = 'vsnip' },
				}, {
					{ name = 'path' }, -- optionally keep path in the secondary bucket
				}),
			})

			-- Cmdline completion for search (keep buffer here if you want search completions)
			cmp.setup.cmdline({ '/', '?' }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = 'buffer' }
				}
			})

			-- Cmdline completion for commands
			cmp.setup.cmdline(':', {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = 'path' }
				}, {
					{ name = 'cmdline' }
				})
			})

			-- ========== Filetype-specific setups ==========

			-- LaTeX (and similar): enable spell + buffer + LSP + snippets
			cmp.setup.filetype('tex', {
				sources = cmp.config.sources({
					{ name = 'spell' },      -- spelling suggestions
					{ name = 'buffer' },     -- buffer completions allowed for tex
					{ name = 'nvim_lsp' },
					{ name = 'vsnip' },
				})
			})

			-- Markdown and plain text: enable spell + buffer as well
			for _, ft in ipairs({ 'markdown', 'text' }) do
				cmp.setup.filetype(ft, {
					sources = cmp.config.sources({
						{ name = 'spell' },
						{ name = 'buffer' },
						{ name = 'nvim_lsp' },
						{ name = 'vsnip' },
					})
				})
			end

			-- If you want buffer completions for specific programming filetypes (optional)
			-- e.g. enable buffer completions for 'rust' and 'python'
			--[[
			for _, ft in ipairs({ 'rust', 'python' }) do
				cmp.setup.filetype(ft, {
					sources = cmp.config.sources({
						{ name = 'nvim_lsp' },
						{ name = 'buffer' },  -- allow buffer completions for these languages
						{ name = 'vsnip' },
					})
				})
			end
			]]

			-- Recommended: enable spell checking only for relevant filetypes
			vim.api.nvim_create_autocmd("FileType", {
				pattern = { "tex", "markdown", "text" },
				callback = function()
					vim.opt_local.spell = true
					vim.opt_local.spelllang = { "en_us" } -- change to en_au if you prefer
				end,
			})
		end,
	}
}

