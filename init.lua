require("config.lazy")
require("config.keymaps")
require("config.options")
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "c", "cpp", "objc", "objcpp", "h", "hpp" },
  callback = function()
    require("config.clangformat").setup()
  end,
})

