
-- ~/.config/nvim/lua/plugins/startup.lua
return {
  {
    "goolord/alpha-nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local dashboard = require("alpha.themes.dashboard")

		-- Set dashboard content
		dashboard.section.header.val = { "" } -- empty header (image replaces it)
		dashboard.section.footer.val = "Welcome, Coder."
		dashboard.section.buttons.val = {
			dashboard.button("ff", " Find File", ":Telescope find_files<CR>"),
			dashboard.button("lg", "󰍉 Find Word", ":Telescope live_grep<CR>"),
			dashboard.button("of", " Recent Files", ":Telescope oldfiles<CR>"),
			dashboard.button("fb", " File Browser", ":Neotree toggle float<CR>"),
			dashboard.button("cs", " Colorschemes", ":Telescope colorscheme<CR>"),
			dashboard.button("nf", " New File", ":enew<CR>"),
			dashboard.button("q", " Quit", ":qa<CR>"),
		}

		alpha.setup(dashboard.config)




		vim.api.nvim_create_autocmd("BufDelete", {
			callback = function()
				vim.defer_fn(function()
					local bufs = vim.fn.getbufinfo()
					local alpha_found = false
					local other_buffers = 0


					for _, buf in ipairs(bufs) do
						if vim.fn.buflisted(buf.bufnr) == 1 and buf.loaded then
							local ft = vim.api.nvim_buf_get_option(buf.bufnr, "filetype")
							local name = vim.api.nvim_buf_get_name(buf.bufnr)
							if ft == "alpha" then
								alpha_found = true
							elseif name ~= "" then
								other_buffers = other_buffers + 1
							end
						end
					end

					-- If no other buffers besides alpha or empty ones
					if other_buffers == 0 then
						if not alpha_found then
							vim.cmd("Alpha")
						end
					end
				end, 1)
			end,
		})

		-- bruh this hack tbh
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				vim.defer_fn(function()
					local bufs = vim.fn.getbufinfo({ buflisted = 1 })
					local only_empty_buffer = (#bufs == 1 and (vim.api.nvim_buf_get_name(bufs[1].bufnr) == ""))

					if only_empty_buffer then
						vim.schedule(function()
							vim.cmd("Alpha")
						end)
					end
				end, 5)
			end,
		})



		-- Override :q to close buffer or quit only if on Alpha
		-- Override :Quit to conditionally quit or buffer delete
		vim.api.nvim_create_user_command("Quit", function(opts)
			if vim.bo.filetype == "alpha" then
				if opts.bang then
					vim.cmd("q!")
				else
					vim.cmd("q")
				end
			else
				if opts.bang then
					vim.cmd("bd!")
				else
					vim.cmd("bd")
				end
			end
		end, { bang = true })

		-- Override :q to close buffer or quit only if on Alpha
		-- Override :Quit to conditionally quit or buffer delete
		vim.api.nvim_create_user_command("QuitAll", function(opts)
			if vim.bo.filetype == "alpha" then
				if opts.bang then
					vim.cmd("qa!")
				else
					vim.cmd("qa")
				end
			else
				if opts.bang then
					vim.cmd("bufdo bd!")
				else
					vim.cmd("bufdo bd")
				end
			end
		end, { bang = true })

		vim.api.nvim_create_user_command("Nuke", function(opts)
			vim.cmd('qa!')
		end, {});


		-- Map :q to :Quit globally
		vim.api.nvim_create_autocmd("CmdlineEnter", {
			callback = function()
				vim.cmd("cnoreabbrev <expr> q getcmdtype() == ':' && getcmdline() == 'q' ? 'Quit' : 'q'")
				vim.cmd("cnoreabbrev <expr> qa getcmdtype() == ':' && getcmdline() == 'qa' ? 'QuitAll' : 'qa'")
			end,
		})




		--   -- Floaty terminal with image
		--   vim.api.nvim_create_autocmd("User", {
			--     pattern = "AlphaReady",
			--     callback = function()
				--       local buf = vim.api.nvim_create_buf(false, true)
				--       local width = math.floor(vim.o.columns * 0.8)
				--       local height = math.floor(vim.o.lines * 0.6)
				--       local row = math.floor((vim.o.lines - height) / 2)
				--       local col = math.floor((vim.o.columns - width) / 2)

   --       local win = vim.api.nvim_open_win(buf, true, {
   --         relative = "editor",
   --         row = row,
   --         col = col,
   --         width = width,
   --         height = height,
   --         style = "minimal",
   --         border = "rounded",
     --     })

   --       vim.fn.termopen({ "cat", vim.fn.expand("~/img3.ans") })
    --     vim.cmd("startinsert")
    --    end,
   --   })
    end,
  },
}
