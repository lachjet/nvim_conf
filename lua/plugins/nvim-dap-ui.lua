return {
  'rcarriga/nvim-dap-ui',
  dependencies = {
    'mfussenegger/nvim-dap',
    'nvim-neotest/nvim-nio',
  },
  config = function()
    local dap   = require("dap")
    local dapui = require("dapui")

    -- 1) dap-ui setup
    dapui.setup()

    -- 2) Override dap’s default terminal command to use Floaterm (30%‐height split)
    dap.defaults.fallback.terminal_win_cmd = "FloatermNew --wintype=split --height=0.3"

    -- 3) Read & parse .nvim/launch.json
    -- ----------------------------------------------------------------------------
    local function load_launch_config()
      local cwd = vim.fn.getcwd()                             -- project root
      local path = cwd .. "/.nvim/launch.json"
      if vim.fn.filereadable(path) == 0 then
        error("Could not find launch.json at " .. path)
      end

      local lines = vim.fn.readfile(path)
      local text  = table.concat(lines, "\n")
      local ok, decoded = pcall(vim.fn.json_decode, text)
      if not ok then
        error("Failed to parse JSON in launch.json: " .. tostring(decoded))
      end
      return decoded
    end

    -- 4) Extract the "executable" field for "Debug (OpenOCD)"
    -- ----------------------------------------------------------------------------
    local function get_executable_path()
      local cfg = load_launch_config()
      local configs = cfg.configurations or {}
      for _, c in ipairs(configs) do
        if c.name == "Debug (OpenOCD)" and c.executable then
          local cwd = vim.fn.getcwd()
          if vim.startswith(c.executable, "./") then
            return cwd .. "/" .. c.executable:sub(3)
		else
			return c.executable
		end
	end
end
error("Configuration named 'Debug (OpenOCD)' not found or missing 'executable'")
	end

	-- 5) dap.adapters: attach to an already‐running OpenOCD on localhost:3333
	-- ----------------------------------------------------------------------------
	dap.adapters.openocd = {
		type = "executable",
		command = "arm-none-eabi-gdb",
		name = "arm-none-eabi-gdb",
		args = { "-q", "--interpreter=mi2" },
	}

	-- 6) dap.configurations: use the executable from launch.json
	-- ----------------------------------------------------------------------------
	dap.configurations.c = {
		{
			name = "Debug (OpenOCD)",
			type = "openocd",
			request = "launch",
			program = get_executable_path,
			cwd = "${workspaceFolder}",
			target = "localhost:3333",
			stopAtEntry = true,
        -- Uncomment the lines below if you need to reset/halt before loading:
        -- preLaunchCommands = {
        --   "monitor reset halt",
        -- },
        -- loadCommands = {
        --   "load",
        -- },
      },
    }
    dap.configurations.cpp = dap.configurations.c

    -- 7) Auto-open/close dap-ui when debugging starts/exits
    -- ----------------------------------------------------------------------------
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- 8) Optional keymaps for common debugging commands
    -- ----------------------------------------------------------------------------
    vim.keymap.set("n", "<F5>", function() dap.continue() end, { desc = "DAP: Continue / Start" })
    vim.keymap.set("n", "<F10>", function() dap.step_over() end,    { desc = "DAP: Step Over" })
    vim.keymap.set("n", "<F11>", function() dap.step_into() end,    { desc = "DAP: Step Into" })
    vim.keymap.set("n", "<F12>", function() dap.step_out() end,     { desc = "DAP: Step Out" })
    vim.keymap.set("n", "<Leader>b", function() dap.toggle_breakpoint() end, { desc = "DAP: Toggle Breakpoint" })
    vim.keymap.set("n", "<Leader>B", function()
      dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "DAP: Conditional Breakpoint" })
    vim.keymap.set("n", "<Leader>dr", function() dap.repl.open() end, { desc = "DAP: Open REPL" })
    vim.keymap.set("n", "<Leader>dl", function() dap.run_last() end,  { desc = "DAP: Run Last" })

    -- 9) (Optional) If you want to launch OpenOCD inside a Floaterm yourself,
    --     add a separate keymap like this (so you don’t have to run it in another terminal):
    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true, silent = true }
    map("n", "<leader>to", ":FloatermNew --wintype=split --height=0.3 openocd -f openocd.cfg<CR>", opts)
    -- Now pressing <leader>to will open OpenOCD in a 30%-height Floaterm split.
  end,
}

