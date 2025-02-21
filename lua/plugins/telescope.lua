return {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
-- or                              , branch = '0.1.x',
	  keys = {
		  {
			  "<C-p>",
			  function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
			  desc = "Find Plugin File",
		  },
		  {
			  "<leader>fg",
			  function() require("telescope.builtin").live_grep({ cwd = require("lazy.core.config").options.root }) end,
			  desc = "Live Grep",
		  }
	  },
      dependencies = { 'nvim-lua/plenary.nvim' }
	}
