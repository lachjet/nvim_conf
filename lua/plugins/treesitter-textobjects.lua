return {
	'nvim-treesitter/nvim-treesitter-textobjects',
	dependencies = { 'nvim-treesitter/nvim-treesitter' }, -- Ensure core treesitter is a dependency
	config = function()
		require('nvim-treesitter.configs').setup({
			-- Basic Treesitter configuration (add your parsers here)
			ensure_installed = {
				"c", "cpp", "lua", "vim", "vimdoc", "javascript", "typescript", "python",
				"html", "css", "json", "yaml", "markdown", "rust", "go", "java"
			},
			highlight = { enable = true },
			indent = { enable = true },

			-- Treesitter Textobjects configuration
			textobjects = {
				select = {
					enable = true,
					-- You can use the default `v`, `V`, `<C-v>` for selection modes
					-- Or define custom ones. For now, we'll use the plugin's default behavior
					-- which makes 'x' and 'o' modes automatically work with these.
					keymaps = {
						-- Around / Inside
						["af"] = { query = "@function.outer", desc = "Around function" },
						["if"] = { query = "@function.inner", desc = "Inside function" },

						["al"] = { query = "@loop.outer", desc = "Around loop" },
						["il"] = { query = "@loop.inner", desc = "Inside loop" },

						["ai"] = { query = "@conditional.outer", desc = "Around conditional" },
						["ii"] = { query = "@conditional.inner", desc = "Inside conditional" },

						-- Note: 'statement.outer/inner' are often used for RHS/LHS approximations
						["ar"] = { query = "@statement.outer", desc = "Around statement (RHS approx)" },
						["ir"] = { query = "@statement.inner", desc = "Inside statement (RHS approx)" },

						["ah"] = { query = "@assignment.outer", desc = "Around assignment (LHS approx)" },
						["ih"] = { query = "@assignment.inner", desc = "Inside assignment (LHS approx)" },

						["av"] = { query = "@variable.outer", desc = "Around variable" },
						["iv"] = { query = "@variable.inner", desc = "Inside variable" },

						["aq"] = { query = "@string.outer", desc = "Around string" },
						["iq"] = { query = "@string.inner", desc = "Inside string" },

						["ak"] = { query = "@class.outer", desc = "Around class" },
						["ik"] = { query = "@class.inner", desc = "Inside class" },

						["aa"] = { query = "@array.outer", desc = "Around array" },
						["ia"] = { query = "@array.inner", desc = "Inside array" },

						["ao"] = { query = "@object.outer", desc = "Around object" },
						["io"] = { query = "@object.inner", desc = "Inside object" },

						["ae"] = { query = "@parameters.outer", desc = "Around parameters" },
						["ie"] = { query = "@parameters.inner", desc = "Inside parameters" },

						["am"] = { query = "@call.outer", desc = "Around call" },
						["im"] = { query = "@call.inner", desc = "Inside call" },

						["at"] = { query = "@type_definition.outer", desc = "Around type definition" },
						["it"] = { query = "@type_definition.inner", desc = "Inside type definition" },

						["ac"] = { query = "@comment.outer", desc = "Around comment" },
						["ic"] = { query = "@comment.inner", desc = "Inside comment" },

						["an"] = { query = "@node.outer", desc = "Around node (general)" },
						["in"] = { query = "@node.inner", desc = "Inside node (general)" },
					},
				},
				move = {
					enable = true,
					set_jumps = true, -- Adds jumps to the jumplist for navigation
					goto_next_start = {
						-- Next start of object (e.g., `]f` for next function start)
						["]f"] = { query = "@function.outer", desc = "Next outer function start" },
						["]F"] = { query = "@function.inner", desc = "Next inner function start" },
						["]l"] = { query = "@loop.outer", desc = "Next outer loop start" },
						["]L"] = { query = "@loop.inner", desc = "Next inner loop start" },
						["]i"] = { query = "@conditional.outer", desc = "Next outer conditional start" },
						["]I"] = { query = "@conditional.inner", desc = "Next inner conditional start" },
						["]r"] = { query = "@statement.outer", desc = "Next outer statement start (RHS approx)" },
						["]R"] = { query = "@statement.inner", desc = "Next inner statement start (RHS approx)" },
						["]h"] = { query = "@assignment.outer", desc = "Next outer assignment start (LHS approx)" },
						["]H"] = { query = "@assignment.inner", desc = "Next inner assignment start (LHS approx)" },
						["]v"] = { query = "@variable.outer", desc = "Next outer variable start" },
						["]q"] = { query = "@string.outer", desc = "Next outer string start" },
						["]Q"] = { query = "@string.inner", desc = "Next inner string start" },
						["]k"] = { query = "@class.outer", desc = "Next outer class start" },
						["]K"] = { query = "@class.inner", desc = "Next inner class start" },
						["]a"] = { query = "@array.outer", desc = "Next outer array start" },
						["]A"] = { query = "@array.inner", desc = "Next inner array start" },
						["]o"] = { query = "@object.outer", desc = "Next outer object start" },
						["]O"] = { query = "@object.inner", desc = "Next inner object start" },
						["]e"] = { query = "@parameters.outer", desc = "Next outer parameters start" },
						["]E"] = { query = "@parameters.inner", desc = "Next inner parameters start" },
						["]m"] = { query = "@call.outer", desc = "Next outer call start" },
						["]M"] = { query = "@call.inner", desc = "Next inner call start" },
						["]t"] = { query = "@type_definition.outer", desc = "Next outer type start" },
						["]T"] = { query = "@type_definition.inner", desc = "Next inner type start" },
						["]c"] = { query = "@comment.outer", desc = "Next outer comment start" },
						["]C"] = { query = "@comment.inner", desc = "Next inner comment start" },
						["]n"] = { query = "@node.outer", desc = "Next outer node start" },
						["]N"] = { query = "@node.inner", desc = "Next inner node start" },
					},
					goto_previous_start = {
						-- Previous start of object (e.g., `[f` for previous function start)
						["[f"] = { query = "@function.outer", desc = "Previous outer function start" },
						["[F"] = { query = "@function.inner", desc = "Previous inner function start" },
						["[l"] = { query = "@loop.outer", desc = "Previous outer loop start" },
						["[L"] = { query = "@loop.inner", desc = "Previous inner loop start" },
						["[i"] = { query = "@conditional.outer", desc = "Previous outer conditional start" },
						["[I"] = { query = "@conditional.inner", desc = "Previous inner conditional start" },
						["[r"] = { query = "@statement.outer", desc = "Previous outer statement start (RHS approx)" },
						["[R"] = { query = "@statement.inner", desc = "Previous inner statement start (RHS approx)" },
						["[h"] = { query = "@assignment.outer", desc = "Previous outer assignment start (LHS approx)" },
						["[H"] = { query = "@assignment.inner", desc = "Previous inner assignment start (LHS approx)" },
						["[v"] = { query = "@variable.outer", desc = "Previous outer variable start" },
						["[q"] = { query = "@string.outer", desc = "Previous outer string start" },
						["[Q"] = { query = "@string.inner", desc = "Previous inner string start" },
						["[k"] = { query = "@class.outer", desc = "Previous outer class start" },
						["[K"] = { query = "@class.inner", desc = "Previous inner class start" },
						["[a"] = { query = "@array.outer", desc = "Previous outer array start" },
						["[A"] = { query = "@array.inner", desc = "Previous inner array start" },
						["[o"] = { query = "@object.outer", desc = "Previous outer object start" },
						["[O"] = { query = "@object.inner", desc = "Previous inner object start" },
						["[e"] = { query = "@parameters.outer", desc = "Previous outer parameters start" },
						["[E"] = { query = "@parameters.inner", desc = "Previous inner parameters start" },
						["[m"] = { query = "@call.outer", desc = "Previous outer call start" },
						["[M"] = { query = "@call.inner", desc = "Previous inner call start" },
						["[t"] = { query = "@type_definition.outer", desc = "Previous outer type start" },
						["[T"] = { query = "@type_definition.inner", desc = "Previous inner type start" },
						["[c"] = { query = "@comment.outer", desc = "Previous outer comment start" },
						["[C"] = { query = "@comment.inner", desc = "Previous inner comment start" },
						["[n"] = { query = "@node.outer", desc = "Previous outer node start" },
						["[N"] = { query = "@node.inner", desc = "Previous inner node start" },
					},
					goto_next_end = {
						-- Next end of object (e.g., `]]f` for next function end)
						-- Note: For these, the queries are the same as start, and treesitter calculates the end.
						["]]f"] = { query = "@function.outer", desc = "Next outer function end" },
						["]]F"] = { query = "@function.inner", desc = "Next inner function end" },
						["]]l"] = { query = "@loop.outer", desc = "Next outer loop end" },
						["]]L"] = { query = "@loop.inner", desc = "Next inner loop end" },
						["]]i"] = { query = "@conditional.outer", desc = "Next outer conditional end" },
						["]]I"] = { query = "@conditional.inner", desc = "Next inner conditional end" },
						["]]r"] = { query = "@statement.outer", desc = "Next outer statement end (RHS approx)" },
						["]]R"] = { query = "@statement.inner", desc = "Next inner statement end (RHS approx)" },
						["]]h"] = { query = "@assignment.outer", desc = "Next outer assignment end (LHS approx)" },
						["]]H"] = { query = "@assignment.inner", desc = "Next inner assignment end (LHS approx)" },
						["]]v"] = { query = "@variable.outer", desc = "Next outer variable end" },
						["]]q"] = { query = "@string.outer", desc = "Next outer string end" },
						["]]Q"] = { query = "@string.inner", desc = "Next inner string end" },
						["]]k"] = { query = "@class.outer", desc = "Next outer class end" },
						["]]K"] = { query = "@class.inner", desc = "Next inner class end" },
						["]]a"] = { query = "@array.outer", desc = "Next outer array end" },
						["]]A"] = { query = "@array.inner", desc = "Next inner array end" },
						["]]o"] = { query = "@object.outer", desc = "Next outer object end" },
						["]]O"] = { query = "@object.inner", desc = "Next inner object end" },
						["]]e"] = { query = "@parameters.outer", desc = "Next outer parameters end" },
						["]]E"] = { query = "@parameters.inner", desc = "Next inner parameters end" },
						["]]m"] = { query = "@call.outer", desc = "Next outer call end" },
						["]]M"] = { query = "@call.inner", desc = "Next inner call end" },
						["]]t"] = { query = "@type_definition.outer", desc = "Next outer type end" },
						["]]T"] = { query = "@type_definition.inner", desc = "Next inner type end" },
						["]]c"] = { query = "@comment.outer", desc = "Next outer comment end" },
						["]]C"] = { query = "@comment.inner", desc = "Next inner comment end" },
						["]]n"] = { query = "@node.outer", desc = "Next outer node end" },
						["]]N"] = { query = "@node.inner", desc = "Next inner node end" },
					},
					goto_previous_end = {
						-- Previous end of object (e.g., `[[f` for previous function end)
						["[[f"] = { query = "@function.outer", desc = "Previous outer function end" },
						["[[F"] = { query = "@function.inner", desc = "Previous inner function end" },
						["[[l"] = { query = "@loop.outer", desc = "Previous outer loop end" },
						["[[L"] = { query = "@loop.inner", desc = "Previous inner loop end" },
						["[[i"] = { query = "@conditional.outer", desc = "Previous outer conditional end" },
						["[[I"] = { query = "@conditional.inner", desc = "Previous inner conditional end" },
						["[[r"] = { query = "@statement.outer", desc = "Previous outer statement end (RHS approx)" },
						["[[R"] = { query = "@statement.inner", desc = "Previous inner statement end (RHS approx)" },
						["[[h"] = { query = "@assignment.outer", desc = "Previous outer assignment end (LHS approx)" },
						["[[H"] = { query = "@assignment.inner", desc = "Previous inner assignment end (LHS approx)" },
						["[[v"] = { query = "@variable.outer", desc = "Previous outer variable end" },
						["[[q"] = { query = "@string.outer", desc = "Previous outer string end" },
						["[[Q"] = { query = "@string.inner", desc = "Previous inner string end" },
						["[[k"] = { query = "@class.outer", desc = "Previous outer class end" },
						["[[K"] = { query = "@class.inner", desc = "Previous inner class end" },
						["[[a"] = { query = "@array.outer", desc = "Previous outer array end" },
						["[[A"] = { query = "@array.inner", desc = "Previous inner array end" },
						["[[o"] = { query = "@object.outer", desc = "Previous outer object end" },
						["[[O"] = { query = "@object.inner", desc = "Previous inner object end" },
						["[[e"] = { query = "@parameters.outer", desc = "Previous outer parameters end" },
						["[[E"] = { query = "@parameters.inner", desc = "Previous inner parameters end" },
						["[[m"] = { query = "@call.outer", desc = "Previous outer call end" },
						["[[M"] = { query = "@call.inner", desc = "Previous inner call end" },
						["[[t"] = { query = "@type_definition.outer", desc = "Previous outer type end" },
						["[[T"] = { query = "@type_definition.inner", desc = "Previous inner type end" },
						["[[c"] = { query = "@comment.outer", desc = "Previous outer comment end" },
						["[[C"] = { query = "@comment.inner", desc = "Previous inner comment end" },
						["[[n"] = { query = "@node.outer", desc = "Previous outer node end" },
						["[[N"] = { query = "@node.inner", desc = "Previous inner node end" },
					},
				},
				swap = {
					enable = true,
					swap = {
						enable = true,
						swap_next = {
							["<leader>sp"] = { query = "@parameter.inner", desc = "Swap next parameter" },
							["<leader>ss"] = { query = "@statement.outer", desc = "Swap next statement" },
							["<leader>sa"] = { query = "@argument.outer", desc = "Swap next argument/array item" },
							-- You can add more swap targets here
						},
						swap_previous = {
							["<leader>sP"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
							["<leader>sS"] = { query = "@statement.outer", desc = "Swap previous statement" },
							["<leader>sA"] = { query = "@argument.outer", desc = "Swap previous argument/array item" },
							-- You can add more swap targets here
						},
					},
				},
				require'nvim-treesitter.configs'.setup {
					incremental_selection = {
						enable = true,
						keymaps = {
							init_selection = "gnn",
							node_incremental = "grn",
							scope_incremental = "grs",
							node_decremental = "grm",
							scope_decremental = "grd",
						},
					},
				}
			},
		})
	end,
}
