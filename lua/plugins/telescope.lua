return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	dependencies = {
		'nvim-lua/plenary.nvim',
		'nvim-telescope/telescope-media-files.nvim',
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		local function custom_file_opener(prompt_bufnr)
			local entry = action_state.get_selected_entry()
			local path = entry.path or entry[1] -- fallback in case `path` is nil

			if not path then return end

			actions.close(prompt_bufnr)

			if path:match("%.pdf$") then
				vim.fn.jobstart({ "zathura", path }, { detach = true })
			elseif path:match("%.png$") or path:match("%.jpg$") or path:match("%.jpeg$") or path:match("%.gif$") then
				vim.fn.jobstart({ "sxiv", path }, { detach = true })
			elseif path:match("%.html$") then
				vim.cmd("FloatermNew --title=preview.html --width=150 --height=50 w3m " .. path)
			else
				vim.cmd("edit " .. vim.fn.fnameescape(path))
			end
		end

		telescope.setup({
			defaults = {
				mappings = {
					i = {
						["<CR>"] = custom_file_opener,
					},
					n = {
						["<CR>"] = custom_file_opener,
					},
				},
			},
			layout_config = {
				horizontal = {
					preview_cutoff = 0,
				},
				vertical = {
					preview_cutoff = 0,
				},
			},
			extensions = {
				media_files = {
					filetypes = { "png", "jpg", "jpeg", "pdf", "gif", "html" },
					find_cmd = "rg",
				},
			},
		})
		telescope.load_extension("media_files")
	end,
}
