-- ~/.config/nvim/lua/plugins/startup.lua
local puffy_ascii = {
  "                            A       ;",
  "                  |   ,--,-/ \\---,-/|  ,",
  "                 _|,\\,'. /|      /|   `/|-.",
  "             \\`.'    /|      ,            `;.",
  "            ,'\\   A     A         A   A _ /| `.;",
  "          ,/  _              A       _  / _   /|  ;",
  "         /\\  / \\   ,  ,           A  /    /     `/|",
  "        /_| | _ \\         ,     ,             ,/  \\",
  "       // | |/ `.\\  ,-      ,       ,   ,/ ,/      \\/",
  "       / @| |@  / /'   \\  \\      ,              >  /|    ,--.",
  "      |\\_/   \\_/ /      |  |           ,  ,/        \\  ./' __:..",
  "      |  __ __  |       |  | .--.  ,         >  >   |-'   /     `",
  "    ,/| /  '  \\ |       |  |     \\      ,           |    /",
  "   /  |<--.__,->|       |  | .    `.        >  >    /   (",
  "  /_,' \\\\  ^  /  \\     /  /   `.    >--            /^\\   |",
  "        \\\\___/    \\   /  /      \\__'     \\   \\   \\/   \\  |",
  "         `.   |/          ,  ,                  /`\\    \\  )",
  "           \\  '  |/    ,       V    \\          /        `-\\",
  "            `|/  '  V      V           \\    \\.'            \\_",
  "             '`-.       V       V        \\./'\\",
  "                 `|/-.      \\ /   \\ /,---`\\         kat",
  "                  /   `._____V_____V'",
  "                             '     '",
  "",
  "         Welcome to Neovim on OpenBSD.",
  "				\"The Most Secure OS in the World\"",
}

local obsd_quotes = {
  "\"What is despair? I have known it—hear my song.\nDespair is when you’re debugging a kernel driver\nand you look at a memory dump and you see that a pointer has a value of 7.\nTHERE IS NO HARDWARE ARCHITECTURE THAT IS ALIGNED ON 7.\nFurthermore, 7 IS TOO SMALL AND ONLY EVIL CODE WOULD TRY TO ACCESS SMALL NUMBER MEMORY.\" – James Mickens",

  "\"I have a network file system, and I have broken the network,\nand I have broken the file system, and my machines crash\nwhen I make eye contact with them.\" – James Mickens",

  "\"I HAVE NO TOOLS BECAUSE I’VE DESTROYED MY TOOLS WITH MY TOOLS.\nMy only logging option is to hire monks to transcribe the subjective experience\nof watching my machines die as I weep tears of blood.\" – James Mickens",

  "\"You might ask, 'Why would someone write code in a grotesque language\nthat exposes raw memory addresses? Why not use a modern language\nwith garbage collection and functional programming and free massages after lunch?'\nHere’s the answer: Pointers are real.\" – James Mickens",

  "\"You can’t just place a LISP book on top of an x86 chip\nand hope that the hardware learns about lambda calculus by osmosis.\" – James Mickens",

  "\"Nothing ruins a Friday at 5 P.M. faster than taking one last pass through the log file\nand discovering a word-aligned buffer address, but a buffer length of NUMBER OF ELECTRONS IN THE UNIVERSE.\" – James Mickens",

  "\"The systems programmer has read the kernel source, to better understand\nthe deep ways of the universe, and the systems programmer has seen\nthe comment in the scheduler that says 'DOES THIS WORK LOL,'\nand the systems programmer has wept instead of LOLed.\" – James Mickens",

  "\"A systems programmer will know what to do when society breaks down,\nbecause the systems programmer already lives in a world without law.\" – James Mickens",

  "\"THERE ARE NO MODAL DIALOGS IN SPARTA.\" – James Mickens",

  "\"As a systems hacker, you must be prepared to do savage things, unspeakable things,\nto kill runaway threads with your bare hands, to write directly to network ports\nusing telnet and an old copy of an RFC.\" – James Mickens",

  "\"An impossibly large buffer error is like a criminal who breaks into your house,\nsprinkles sand atop random bedsheets and toothbrushes, and then waits\nfor you to slowly discover that your world has been tainted by madness.\" – James Mickens",

  "\"Indeed, the common discovery mode for an impossibly large buffer error\nis that your program seems to be working fine, and then it tries to display a string\nthat should say “Hello world,” but instead it prints “#a[5]:3!”\nor another syntactically correct Perl script.\" – James Mickens",

  "\"There is nothing funny to print when you have a misaligned memory access,\nbecause your machine is dead and there are no printers in the spirit world.\" – James Mickens",
}


return {
	{
		"goolord/alpha-nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local alpha = require("alpha")
			local dashboard = require("alpha.themes.dashboard")



			dashboard.section.header.val = puffy_ascii;


			math.randomseed(os.time()) -- seed once
			local quote = obsd_quotes[math.random(#obsd_quotes)]

			-- leader<m> should act like <leader>b (:#b) when there is a previous buffer
			-- otherwise if not it should act like nf (":enew")
			vim.api.nvim_create_user_command("SmartMenuToggle", function()
				local alt_buf = vim.fn.bufnr("#")
				if alt_buf > 0 and vim.fn.bufexists(alt_buf) == 1 and vim.fn.buflisted(alt_buf) == 1 then
					vim.cmd("b#")
				else
					vim.cmd("enew")
				end
			end, {})

			dashboard.section.footer.val = quote
			dashboard.section.buttons.val = {
				dashboard.button("ff", "  Find File", ":Telescope find_files<CR>"),
				dashboard.button("lg", "󰍉  Find Word", ":Telescope live_grep<CR>"),
				dashboard.button("of", "  Recent Files", ":Telescope oldfiles<CR>"),
				dashboard.button("fb", "  File Browser", ":Neotree toggle float<CR>:set relativenumber<CR>"),
				dashboard.button("cs", "  Colorschemes", ":Telescope colorscheme<CR>"),
				dashboard.button("nf", "  New File", ":enew<CR>"),
				dashboard.button("<leader>m", "󱁍  Toggle Menu", ":SmartMenuToggle<CR>"),
				dashboard.button("<leader>b", "󰜉  Open Previous Buffer", ":b#<CR>"),
				dashboard.button("q", "   Quit", ":q<CR>"),
				dashboard.button("rq","  Regenerate Quote (Broken)",  vim.api.nvim_create_user_command("AlphaQuote", function()
					dashboard.section.footer.val = get_random_quote()
					require("alpha").setup(dashboard.opts)
				end, {})),
			}

			alpha.setup(dashboard.config)

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
