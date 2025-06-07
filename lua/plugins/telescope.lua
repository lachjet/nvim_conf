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
		local file_utils = require("config.file-to-application")


		local function custom_file_opener(prompt_bufnr)
			local entry = action_state.get_selected_entry()
			local path = entry.path or entry.filename or entry[1]
			local lnum = entry.lnum
			if not path then return end

			actions.close(prompt_bufnr)

			if type(path) ~= "string" or path == "" then
				print("Invalid path: " .. tostring(path))
				return
			end

			if not file_utils.open_file(path) then
				vim.cmd("edit " .. vim.fn.fnameescape(path))
			end

			if lnum then
				vim.schedule(function()
					vim.api.nvim_win_set_cursor(0, { lnum, 0 })
				end)
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
