local function open_project_picker()
	local conduct_path = vim.fn.stdpath("data") .. "/conduct"
	local dirs = vim.fn.globpath(conduct_path, "*/", false, true)

	if #dirs == 0 then
		vim.notify("No conduct projects found.", vim.log.levels.WARN)
		return
	end

	local projects = {}
	for _, dir in ipairs(dirs) do
		local clean_dir = dir:gsub("[\r\n\t ]+$", ""):gsub("/$", "")
		local name = clean_dir:match("^.+/(.+)$") or clean_dir
		table.insert(projects, name)
	end


	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.tbl_map(function(name)
		return name
	end, projects))

	vim.keymap.set("n", "q", "<cmd>bd!<CR>", { buffer = buf })

	vim.keymap.set("n", "<CR>", function()
		local line = vim.api.nvim_win_get_cursor(0)[1]
		local project = projects[line]
		if project then
			if vim.api.nvim_win_is_valid(win) then
				vim.api.nvim_win_close(win, true)
			end
			vim.cmd("ConductLoadProject " .. project)
		end
	end, { buffer = buf, nowait = true })

	local width = 40
	local height = #projects + 2
	win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		row = (vim.o.lines - height) / 2,
		col = (vim.o.columns - width) / 2,
		style = "minimal",
		border = "rounded",
	})

	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.api.nvim_buf_set_option(buf, "filetype", "conductmenu")
	vim.api.nvim_win_set_option(win, "cursorline", true)
end

-- ~/.config/nvim/lua/plugins/conduct.lua
return {
	"aaditeynair/conduct.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		require("conduct").setup({
			hooks = {
				after_project_load = function()
					local init_path = vim.fn.getcwd() .. "/.conduct/init.lua"
					if vim.fn.filereadable(init_path) == 1 then
						local ok, mod = pcall(dofile, init_path)
						if not ok then
							vim.notify("Failed to load .conduct/init.lua: " .. mod, vim.log.levels.ERROR)
							return
						end
						if type(mod) == "table" and type(mod.keybinds) == "function" then
							for _, bind in ipairs(mod.keybinds()) do
								vim.keymap.set("n", bind.key, bind.run, { desc = bind.name })
							end
						else
							vim.notify("Invalid .conduct/init.lua: no keybinds() function", vim.log.levels.ERROR)
						end
					end
				end
			}
		})
		require("telescope").load_extension("conduct")
		vim.api.nvim_create_user_command("ConductBrowseProjects", open_project_picker, {})
	end,
}
