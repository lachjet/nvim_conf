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
    ------------------------------------------------------------
    dap_cd.setup({
      node_path            = "node",
      dapui_rtt            = true,
      dap_vscode_filetypes = { "c", "cpp" },
      rtt                  = { buftype = "Terminal" },
    })

    ------------------------------------------------------------
    -- 3) Override dap’s default terminal to use Floaterm
    ------------------------------------------------------------
    dap.defaults.fallback.terminal_win_cmd = "FloatermNew --wintype=split --height=0.3"

    ------------------------------------------------------------
    -- 4) Helpers to read .nvim/launch.json and extract “executable”
    ------------------------------------------------------------
    local function load_launch_config()
      local cwd  = vim.fn.getcwd()
      local path = cwd .. "/.nvim/launch.json"
      if vim.fn.filereadable(path) == 0 then
        error("Could not find launch.json at " .. path)
      end
      local lines   = vim.fn.readfile(path)
      local content = table.concat(lines, "\n")
      local ok, cfg = pcall(vim.fn.json_decode, content)
      if not ok then
        error("Failed to parse JSON in launch.json: " .. tostring(cfg))
      end
      return cfg
    end

    local function get_executable_from_json()
      local cfgs = load_launch_config().configurations or {}
      for _, c in ipairs(cfgs) do
        if c.name == "Debug (OpenOCD)" and c.executable then
          local cwd = vim.fn.getcwd()
          if vim.startswith(c.executable, "./") then
            return cwd .. "/" .. c.executable:sub(3)
          else
            return c.executable
          end
        end
      end
      error("No 'Debug (OpenOCD)' entry or missing 'executable' in launch.json")
    end

    ------------------------------------------------------------
    -- 5) Define your C configuration via openocd_config:
    ------------------------------------------------------------
    dap.configurations.c = {
      dap_cd.openocd_config {
        name       = "Debug (OpenOCD)",
        cwd        = "${workspaceFolder}",

        -- Read from launch.json:
        executable = get_executable_from_json(),

        -- Paths to your OpenOCD config file(s):
        configFiles = {
          "${workspaceFolder}/openocd.cfg",
        },

        -- GDB server address:
        gdbTarget   = "localhost:3333",

        -- (Optional) RTT on port 0:
        rttConfig   = dap_cd.rtt_config(0),

        -- Hide verbose GDB-server logs:
        showDevDebugOutput = false,
      },
    }
    dap.configurations.cpp = dap.configurations.c

    ------------------------------------------------------------
    -- 6) Auto‐open / close dap‐ui
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
    -- 7) Updated keymaps for debugging:
    ------------------------------------------------------------
    vim.keymap.set("n", "<Leader>zc", function() dap.continue() end, { desc = "DAP: Continue / Start" })
    vim.keymap.set("n", "<Leader>zz", function() dap.step_over() end,    { desc = "DAP: Step Over" })
    vim.keymap.set("n", "<Leader>zx", function() dap.step_into() end,    { desc = "DAP: Step Into" })
    vim.keymap.set("n", "<Leader>zd", function() dap.step_out() end,     { desc = "DAP: Step Out" })
    vim.keymap.set("n", "<Leader>b",  function() dap.toggle_breakpoint() end, { desc = "DAP: Toggle Breakpoint" })
	vim.keymap.set("n", "<Leader>zt", function() dap.terminate() end,	{ desc = "DAP: Terminate" })
    vim.keymap.set("n", "<Leader>B",  function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "DAP: Conditional Breakpoint" })
    vim.keymap.set("n", "<Leader>zl", function() dap.run_last() end,     { desc = "DAP: Run Last" })

    ------------------------------------------------------------
    -- 8) (Optional) Launch OpenOCD in Floaterm via <Leader>to:
    ------------------------------------------------------------
    local map, opts = vim.api.nvim_set_keymap, { noremap = true, silent = true }
    map("n", "<Leader>to", ":FloatermNew --wintype=split --height=0.3 openocd -f openocd.cfg<CR>", opts)
  end,
}

