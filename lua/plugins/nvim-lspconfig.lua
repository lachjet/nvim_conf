return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "hrsh7th/cmp-nvim-lsp" },

    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.diagnostic.config({
        virtual_text     = false,
        signs            = true,
        underline        = true,
        update_in_insert = false,
        severity_sort    = false,
      })

      local on_attach = function(client, bufnr)
        local map = function(mode, lhs, rhs)
          vim.keymap.set(mode, lhs, rhs, { noremap = true, silent = true, buffer = bufnr })
        end

        map("n", "K",          vim.lsp.buf.hover)
        map("n", "gd",         vim.lsp.buf.definition)
        map("n", "<Leader>c",  function() vim.lsp.buf.code_action({ apply = false }) end)
        map("n", "[d",         vim.diagnostic.goto_prev)
        map("n", "]d",         vim.diagnostic.goto_next)
        map("n", "<Leader>e",  function() vim.diagnostic.open_float(nil, { focus = false }) end)

        -- Python REPL keybindings
        if vim.bo[bufnr].filetype == "python" then
          map("n", "<Leader>re",
            "<cmd>FloatermNew! --name=python3 --wintype=float --autoclose=0 python3; exit<CR>")
          map("n", "<Leader>rd",
            "<cmd>FloatermNew! --name=python3 --wintype=split --position=bottom --height=15 python3; exit<CR>")

          local function venv_command()
            local cwd = vim.fn.getcwd()
            local venv_path = cwd .. "/venv/bin/activate"
            if vim.fn.filereadable(venv_path) == 1 then
              return string.format("source %s && clear", venv_path)
            else
              return "python3 -m venv venv && source venv/bin/activate && clear"
            end
          end

          map("n", "<Leader>vt", function()
            vim.cmd(string.format("FloatermNew! --name=venv --wintype=float --autoclose=0 %s", venv_command()))
          end)
          map("n", "<Leader>vd", function()
            vim.cmd(string.format("FloatermNew! --name=venv --wintype=split --position=bottom --height=15 --autoclose=0 %s", venv_command()))
          end)
        end
      end

      -- 0.9.5-compatible root finder
      local function find_root(markers)
        return vim.fn.fnamemodify(
          vim.fs.find(markers, { upward = true })[1] or "", ":h"
        )
      end

      ------------------------
      -- pylsp (Python)
      ------------------------
      require("lspconfig").pylsp.setup({
        on_attach    = on_attach,
        capabilities = capabilities,
      })

      ------------------------
      -- ts_ls (JS / TS)
      ------------------------
      require("lspconfig").ts_ls.setup({
        on_attach    = on_attach,
        capabilities = capabilities,
        root_dir     = find_root({ "package.json", "tsconfig.json", ".git" }),
      })

      ------------------------
      -- html (HTML)
      ------------------------
      require("lspconfig").html.setup({
        on_attach    = on_attach,
        capabilities = capabilities,
        filetypes    = { "html" },
      })

      ------------------------
      -- cssls (CSS / SCSS / LESS)
      ------------------------
      require("lspconfig").cssls.setup({
        on_attach    = on_attach,
        capabilities = capabilities,
        filetypes    = { "css", "scss", "less" },
      })

      vim.fn.sign_define("DiagnosticSignError", { text = "✖", texthl = "DiagnosticError" })
      vim.fn.sign_define("DiagnosticSignWarn",  { text = "⚠", texthl = "DiagnosticWarn"  })
      vim.fn.sign_define("DiagnosticSignInfo",  { text = "ℹ", texthl = "DiagnosticInfo"  })
      vim.fn.sign_define("DiagnosticSignHint",  { text = "➤", texthl = "DiagnosticHint"  })
    end,
  }
}
