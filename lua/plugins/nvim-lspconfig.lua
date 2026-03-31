return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "hrsh7th/cmp-nvim-lsp" },

    config = function()
      --------------------------------------------------------------------------
      -- Common settings
      --------------------------------------------------------------------------
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.diagnostic.config({
        virtual_text     = false,
        signs            = true,
        underline        = true,
        update_in_insert = false,
        severity_sort    = false,
      })

      --------------------------------------------------------------------------
      -- on_attach callback
      --------------------------------------------------------------------------
      local on_attach = function(client, bufnr)
        local map = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
        end

        -- General LSP mappings
        map("n", "K",  vim.lsp.buf.hover)
        map("n", "gd", vim.lsp.buf.definition)
        map("n", "<Leader>c", function() vim.lsp.buf.code_action({ apply = false }) end)

        -- Diagnostics
        map("n", "[d", vim.diagnostic.goto_prev)
        map("n", "]d", vim.diagnostic.goto_next)
        map("n", "<Leader>e", function()
          vim.diagnostic.open_float(nil, { focus = false })
        end)

        -- Python REPL
        if vim.bo[bufnr].filetype == "python" then
          map("n", "<Leader>re",
            "<cmd>FloatermNew! --name=python3 --wintype=float --autoclose=0 python3; exit<CR>")
          map("n", "<Leader>rd",
            "<cmd>FloatermNew! --name=python3 --wintype=split --position=bottom --height=15 python3; exit<CR>")
        end

        -- MATLAB REPL
        if vim.bo[bufnr].filetype == "matlab" then
          map("n", "<Leader>re",
            "<cmd>FloatermNew! --name=MATLAB_REPL --wintype=float --autoclose=0 /usr/local/MATLAB/R2025a/bin/matlab -nodesktop -nosplash; exit<CR>")
          map("n", "<Leader>rd",
            "<cmd>FloatermNew! --name=MATLAB_REPL --wintype=split --position=bottom --height=15 /usr/local/MATLAB/R2025a/bin/matlab -nodesktop -nosplash; exit<CR>")
        end
      end

				if vim.bo[bufnr].filetype == "python" then
					local buf_map = vim.api.nvim_buf_set_keymap
					local opts = { noremap = true, silent = true }

					-- Basic REPLs (your existing ones)
					buf_map(bufnr, 'n', '<Leader>re',
						'<cmd>FloatermNew! --name=python3 --wintype=float --autoclose=0 python3; exit<CR>', opts)
					buf_map(bufnr, 'n', '<Leader>rd',
						'<cmd>FloatermNew! --name=python3 --wintype=split --position=bottom --height=15 python3; exit<CR>', opts)

					-- Helper function to build shell command for venv terminal
					local function venv_command()
						-- get current working directory (project root)
						local cwd = vim.fn.getcwd()
						local venv_path = cwd .. "/venv/bin/activate"
						local cmd = ""

						-- If venv exists: just activate it
						if vim.fn.filereadable(venv_path) == 1 then
							cmd = string.format("source %s && clear", venv_path)
						else
							-- Otherwise create venv, then activate
							cmd = "python3 -m venv venv && source venv/bin/activate && clear"
						end
						return cmd
					end

					-- Floating venv terminal (<Leader>vt)
					vim.keymap.set("n", "<Leader>vt", function()
						local cmd = venv_command()
						vim.cmd(string.format("FloatermNew! --name=venv --wintype=float --autoclose=0 %s", cmd))
					end, { noremap = true, silent = true, buffer = bufnr, desc = "Floating venv terminal" })

					-- Docked venv terminal (<Leader>vd)
					vim.keymap.set("n", "<Leader>vd", function()
						local cmd = venv_command()
						vim.cmd(string.format("FloatermNew! --name=venv --wintype=split --position=bottom --height=15 --autoclose=0 %s", cmd))
					end, { noremap = true, silent = true, buffer = bufnr, desc = "Docked venv terminal" })
				end


				-- MATLAB-specific keybindings
				if vim.bo[bufnr].filetype == 'matlab' then
					buf_map(bufnr, 'n', '<Leader>re',
						'<cmd>FloatermNew! --name=MATLAB_REPL --wintype=float --autoclose=0 /usr/local/MATLAB/R2025a/bin/matlab -nodesktop -nosplash; exit<CR>', opts)
					buf_map(bufnr, 'n', '<Leader>rd',
						'<cmd>FloatermNew! --name=MATLAB_REPL --wintype=split --position=bottom --height=15 /usr/local/MATLAB/R2025a/bin/matlab -nodesktop -nosplash; exit<CR>', opts)
				end
			end

      ------------------------
      -- clangd
      ------------------------
      vim.lsp.config("clangd", {
        cmd = {
          "clangd",
          "--background-index",
          "--enable-config",
          "--compile-commands-dir=build",
        },
        filetypes = { "c", "cpp", "objc", "objcpp" },
        root_dir = vim.fs.root(0, { ".clangd" }),
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable("clangd")

      ------------------------
      -- neocmake
      ------------------------
	  vim.lsp.config("neocmake", {
	    cmd = vim.lsp.rpc.connect("127.0.0.1", 9257), -- FIXED here
	    filetypes = { "cmake" },
	    root_dir = and_root_dir,
	    single_file_support = true,
	    enable_external_cmake_lint = true,
	    on_attach = on_attach,
	    capabilities = capabilities,
	    init_options = {
	      format = { enable = true },
	    },
	  })
	  vim.lsp.enable("neocmake")


      ------------------------
      -- lua_ls
      ------------------------
      vim.lsp.config("lua_ls", {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable("lua_ls")

      ------------------------
      -- texlab
      ------------------------
      vim.lsp.config("texlab", {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable("texlab")

      ------------------------
      -- MATLAB LS
      ------------------------
      vim.lsp.config("matlab_ls", {
        cmd = {
          "node",
          "/home/lachjet/MATLAB-language-server/out/index.js",
          "--stdio",
          "--matlabInstallPath=/usr/local/MATLAB/latest",
        },
        filetypes = { "matlab" },
        root_dir = vim.fs.root(0, { ".git", "." }),
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = {
          ["textDocument/publishDiagnostics"] =
            vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
              virtual_text = true,
              signs = true,
              underline = true,
              update_in_insert = false,
            }),
        },
      })
      vim.lsp.enable("matlab_ls")

      ------------------------
      -- pylsp
      ------------------------
      vim.lsp.config("pylsp", {
        on_attach = on_attach,
        capabilities = capabilities,
      })
      vim.lsp.enable("pylsp")

      --------------------------------------------------------------------------
      -- Diagnostic Signs
      --------------------------------------------------------------------------
      vim.fn.sign_define("DiagnosticSignError", { text = "✖", texthl = "DiagnosticError" })
      vim.fn.sign_define("DiagnosticSignWarn",  { text = "⚠", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DiagnosticSignInfo",  { text = "ℹ", texthl = "DiagnosticInfo" })
      vim.fn.sign_define("DiagnosticSignHint",  { text = "➤", texthl = "DiagnosticHint" })
    end,
  }
}

