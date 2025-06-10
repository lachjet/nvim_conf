return {
  'rcarriga/nvim-dap-ui',
  dependencies = {
    'mfussenegger/nvim-dap',
    'nvim-neotest/nvim-nio',
    'jedrzejboczar/nvim-dap-cortex-debug',
  },
  config = function()
    local dap    = require("dap")
    local dapui  = require("dapui")
    local dap_cd = require("dap-cortex-debug")

    ------------------------------------------------------------
    -- 1) dap-ui setup
    ------------------------------------------------------------
    dapui.setup()

    ------------------------------------------------------------
    -- 2) cortex-debug’s setup() (registers adapter & listeners)
    --    ONLY if launch.json exists
    ------------------------------------------------------------
    local function file_exists(path)
      return vim.fn.filereadable(path) == 1
    end

    local function get_launch_json_path()
      return vim.fn.getcwd() .. "/.nvim/launch.json"
    end

    local function load_launch_config()
      local path = get_launch_json_path()
      if not file_exists(path) then
        return nil
      end

      local lines   = vim.fn.readfile(path)
      local content = table.concat(lines, "\n")
      local ok, cfg = pcall(vim.fn.json_decode, content)
      if not ok then
        vim.notify("nvim-dap-ui: failed to parse launch.json: " .. tostring(cfg),
                   vim.log.levels.ERROR)
        return nil
      end
      return cfg
    end

    local function get_executable_from_json()
      local cfg = load_launch_config()
      if not cfg or type(cfg.configurations) ~= "table" then
        return nil
      end

      for _, c in ipairs(cfg.configurations) do
        if c.name == "Debug (OpenOCD)" and c.executable then
          local exe = c.executable
          if vim.startswith(exe, "./") then
            return vim.fn.getcwd() .. "/" .. exe:sub(3)
          else
            return exe
          end
        end
      end

      return nil
    end

    -- Only run cortex-debug setup if we found a valid executable
    local executable = get_executable_from_json()
    if executable then
      dap_cd.setup({
        node_path            = "node",
        dapui_rtt            = true,
        dap_vscode_filetypes = { "c", "cpp" },
        rtt                  = { buftype = "Terminal" },
      })
    end

    ------------------------------------------------------------
    -- 3) Override dap’s default terminal to use Floaterm
    ------------------------------------------------------------
    dap.defaults.fallback.terminal_win_cmd = "FloatermNew --wintype=split --height=0.3"

    ------------------------------------------------------------
    -- 4) Define your C/C++ configuration via openocd_config,
    --    ONLY if we actually have an executable
    ------------------------------------------------------------
    if executable then
      dap.configurations.c = {
        dap_cd.openocd_config {
          name       = "Debug (OpenOCD)",
          cwd        = "${workspaceFolder}",
          executable = executable,
          configFiles = {
            "${workspaceFolder}/openocd.cfg",
          },
          gdbTarget   = "localhost:3333",
          rttConfig   = dap_cd.rtt_config(0),
          showDevDebugOutput = false,
        },
      }
      dap.configurations.cpp = dap.configurations.c
    end

    ------------------------------------------------------------
    -- 5) Auto‐open / close dap‐ui
    ------------------------------------------------------------
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    ------------------------------------------------------------
    -- 6) Updated keymaps for debugging
    ------------------------------------------------------------
    vim.keymap.set("n", "<Leader>zc", function() dap.continue() end,
      { desc = "DAP: Continue / Start" })
    vim.keymap.set("n", "<Leader>zz", function() dap.step_over() end,
      { desc = "DAP: Step Over" })
    vim.keymap.set("n", "<Leader>zx", function() dap.step_into() end,
      { desc = "DAP: Step Into" })
    vim.keymap.set("n", "<Leader>zd", function() dap.step_out() end,
      { desc = "DAP: Step Out" })
    vim.keymap.set("n", "<Leader>zb", function() dap.toggle_breakpoint() end,
      { desc = "DAP: Toggle Breakpoint" })
    vim.keymap.set("n", "<Leader>zt", function() dap.terminate() end,
      { desc = "DAP: Terminate" })
    vim.keymap.set("n", "<Leader>B", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "DAP: Conditional Breakpoint" })
    vim.keymap.set("n", "<Leader>zl", function() dap.run_last() end,
      { desc = "DAP: Run Last" })

    ------------------------------------------------------------
    -- 7) (Optional) Launch OpenOCD in Floaterm via <Leader>to
    ------------------------------------------------------------
    local map, opts = vim.api.nvim_set_keymap, { noremap = true, silent = true }
    map("n", "<Leader>to",
      ":FloatermNew --wintype=split --height=0.3 openocd -f openocd.cfg<CR>",
      opts)
  end,
}
