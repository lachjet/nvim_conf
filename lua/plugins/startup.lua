-- ~/.config/nvim/lua/plugins/startup.lua
local dragon_asci = {
				"														____________",
				"  _   ___     _____ __  __      (`-..________....---''  ____..._.-`",
				" | \\ | \\ \\   / /_ _|  \\/  |     \\\\`._______.._,.---'''     ,'",
				" |  \\| |\\ \\ / / | || |\\/| |     ; )`.      __..-'`-.      /",
				" | |\\  | \\ V /  | || |  | |     / /     _.-' _,.;;._ `-._,'",
				" |_| \\_|  \\_/  |___|_|  |_|    / /   ,-' _.-'  //   ``--._``._",
				"                              ,','_.-' ,-' _.- (( =-    -. `-._`-._____",
				"                           ,;.''__..-'   _..--.\\\\.--'````--.._``-.`-._`.",
				"             _          |\\,' .-''        ```-'`---'`-...__,._  ``-.`-.`-.`.",
				"  _     _.-,'(__)\\__)\\-'' `     ___  .          `     \\      `--._",
				",',)---' /|)          `     `      ``-.   `     /     /     `     `-.",
				"\\_____--.  '`  `               __..-.  \\     . (   < _...-----..._   `.",
				" \\_,--..__. \\\\ .-`.\\----'';``,..-.__ \\  \\      ,`_. `.,-'`--'`---''`.  )",
				"           `.\\`.\\  `_.-..' ,'   _,-..'  /..,-''(, ,' ; ( _______`___..'__",
				"                   ((,(,__(    ((,(,__,'  ``'-- `'`.(\\  `.,..______   SSt",
				"                                                      ``--------..._``--.__",
				"Welcome to Neovim, Weary Traveler, Hope you're coding journey goes smoothly."
}

local quotes = {
	"\"Even the smallest person can change the course of the future.\" – Galadriel",
	"\"A wizard is never late, nor is he early. He arrives precisely\n when he means to.\" – Gandalf",
	"\"Courage need not be remembered, for it is never forgotten.\" – Zelda",
	"\"The man who passes the sentence should swing the sword.\" – Eddard Stark",
	"\"Fear cuts deeper than swords.\" – Arya Stark",
	"\"Valar morghulis.\" – Jaqen H'ghar",
	"\"The road goes ever on and on.\" – Bilbo Baggins",
	"\"There is always hope.\" – Aragorn",
	"\"In the end, we only regret the chances we didn’t take.\" – Dwarven proverb",
	"\"Faithless is he that says farewell when the road darkens.\" – Gimli",
	"\"Do not pity the dead, Harry. Pity the living, and above all, \n those who live without love.\" – Dumbledore",
	"\"May your blade never dull.\" – Witcher saying",
	"\"The cake is a lie.\" – Portal (not medieval, but a cult classic twist quote)",
	"\"You mustn’t be afraid to dream a little bigger, darling.\" \n– Inception (fantasy-themed mindset)",
	"\"All we have to decide is what to do with the time that is given\n to us.\" – Gandalf",
	"\"Bravery is not the absence of fear, but the will to overcome it.\"\n – Knight’s Creed",
	"\"Speak, friend, and enter.\" – Inscription on the Doors of Durin",
	"\"Magic is believing in yourself. If you can do that, you can\n make anything happen.\" – Goethe",
	"\"Do not go gentle into that good night.\" \n – Dylan Thomas (often quoted in fantasy tone)",
	"\"The only way to do the impossible is to believe it is possible.\"\n – Alice in Wonderland",
	"\"No man can kill me.\" – Witch-King of Angmar",
	"\"One voice can change the world.\" – Eragon",
	"\"The night is dark and full of terrors.\" – Melisandre",
	"\"I am the sword in the darkness.\" – The Night’s Watch Oath",
	"\"Winter is coming.\" – House Stark",
	"\"Honor is not in a name. It's in the actions we take.\" – Unknown knight",
	"\"That still only counts as one! – Gimli, *The Lord of the Rings*",
	"\"Dovahkiin, Dovahkiin naal ok zin los vahriin\nWahdein vokul mahfaeraak ast vaal\" – The Dragonborn Comes (Skyrim)",
}

return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")



			dashboard.section.header.val = dragon_asci;




			math.randomseed(os.time()) -- seed once
			local quote = quotes[math.random(#quotes)]



			dashboard.section.footer.val = quote
			dashboard.section.buttons.val = {
				dashboard.button("ff", " Find File", ":Telescope find_files<CR>"),
				dashboard.button("lg", "󰍉 Find Word", ":Telescope live_grep<CR>"),
				dashboard.button("of", " Recent Files", ":Telescope oldfiles<CR>"),
				dashboard.button("fb", " File Browser", ":Neotree toggle float<CR>"),
				dashboard.button("cs", " Colorschemes", ":Telescope colorscheme<CR>"),
				dashboard.button("nf", " New File", ":enew<CR>"),
				dashboard.button("q", " Quit", ":qa<CR>"),
				dashboard.button("rq","  Regenerate Quote (Broken)",  vim.api.nvim_create_user_command("AlphaQuote", function()
					dashboard.section.footer.val = get_random_quote()
					require("alpha").setup(dashboard.opts)
				end, {})),
			}

			alpha.setup(dashboard.config)

			local alpha = require("alpha")
			-- The following code is to prevent users from accidentially closing the entire neovim session
			-- when the last buffer is closed. Instead open alpha -- and only when alpha is open can we
			-- actually close the session.

			-- Map :q to :Quit globally
			-- By remapping this we can handle this manually 
			vim.api.nvim_create_autocmd("CmdlineEnter", {
				callback = function()
					vim.cmd("cnoreabbrev <expr> q getcmdtype() == ':' && getcmdline() == 'q' ? 'Quit' : 'q'")
					vim.cmd("cnoreabbrev <expr> qa getcmdtype() == ':' && getcmdline() == 'qa' ? 'QuitAll' : 'qa'")
				end,
			})

			-- Basically here we define out new "Quit" to close the current buffer instead of
			-- properly quit -- this is to ensure that if we quit the last buffer we don't 
			-- exit nvim. Further, we need to map the force commands on the bang accordingly,
			-- to ensure it doesn't throw a tantroom when we need to force close a buffer.
			--
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

			-- Same story here as above -- however for the all version
			-- this version will close all active buffers that it can
			-- then the bufclose autocommand callback will catch the buffer
			-- close and handle accordingly
			--
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

			-- This is the autocommand callback on buffer delete
			-- it effectively just opens Alpha if all the other buffers are closed
			-- if there are any modified buffers that haven't been saved yet, it will
			-- instead focus those for the user the act accordingly
			vim.api.nvim_create_autocmd("BufDelete", {
				callback = function()
					vim.defer_fn(function()
						local bufs = vim.fn.getbufinfo()
						local alpha_found = false
						local other_buffers = 0
						local fallback_buf = nil

						for _, buf in ipairs(bufs) do
							if buf.listed == 1 and buf.loaded then
								local ft = vim.api.nvim_buf_get_option(buf.bufnr, "filetype")
								local name = vim.api.nvim_buf_get_name(buf.bufnr)
								local modified = buf.changed == 1

								if ft == "alpha" then
									alpha_found = true
								elseif name ~= "" then
									other_buffers = other_buffers + 1
									if not fallback_buf and (modified or name ~= "") then
										fallback_buf = buf.bufnr
									end
								end
							end
						end

						if other_buffers == 0 then
							if not alpha_found then
								-- If there's a modified buffer still in memory, go back to it
								if fallback_buf then
									print("Fallback")
									vim.api.nvim_set_current_buf(fallback_buf)
								else
									print("Alpha")
									alpha.start(true)
								end
							end
						end
					end, 1)
				end,
			})

			-- This little addition is to handle the edge case where a user decides to be a little bitch and close
			-- the alpha buffer without quitting nvim. When this happens it will throw an error. 
			vim.api.nvim_create_autocmd("CmdlineEnter", {
				callback = function()
					vim.cmd([[
					cnoreabbrev <expr> bd
					\ (getcmdtype() == ':' && &filetype == 'alpha') ? 'echo "Cannot :bd on Alpha screen"' : 'bd'
					]])
				end,
			})

			-- Now to implement everyone's favourite command - nuke. Now naturally bugs
			-- may occur or else a session might get corrupted for whatever reason either related
			-- to this or not. Nuke just gives users a doorway to entirely nuke a session from
			-- anywhere.
			vim.api.nvim_create_user_command("Nuke", function(opts)
				vim.cmd('qa!')
			end, {});
		end,
	},
}
