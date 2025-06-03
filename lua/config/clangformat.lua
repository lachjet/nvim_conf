-- lua/config/clangformat.lua
--
-- This file sets up clang‐format mappings for C/C++/header files:
--  • In Visual mode, “=“ will pipe the selection through clang-format.
--  • In Normal mode, “==“ will format the current line.
--  • “<Leader>cf“ will format the entire buffer.

local M = {}

function M.setup()
  -- 1) Make sure Vim’s built-in formatprg is unset so “=” doesn’t use =builtin
  vim.opt_local.formatprg = ""

  -- Helper: run clang-format on a given (start_line, end_line) range
  local function clang_range(s, e)
    -- Construct an Ex command like “:3,10!clang-format”
    vim.cmd(string.format("%d,%d!clang-format", s, e))
  end

  -- 2) Visual mode “=” → format selection
  vim.keymap.set("v", "=", function()
    local start_line = vim.fn.line("'<")
    local end_line   = vim.fn.line("'>")
    clang_range(start_line, end_line)
  end, { buffer = true, silent = true })

  -- 3) Normal mode “==” → format current line
  vim.keymap.set("n", "==", function()
    local cur = vim.fn.line(".")
    clang_range(cur, cur)
  end, { buffer = true, silent = true })

  -- 4) Normal mode “<Leader>cf” → format whole buffer (1,$)
  vim.keymap.set("n", "<Leader>cf", function()
    local last = vim.fn.line("$")
    clang_range(1, last)
  end, { buffer = true, silent = true })
end

return M
