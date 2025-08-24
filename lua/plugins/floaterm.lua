return {
  'voldikss/vim-floaterm',
  config = function()
    -- make floaterm use :edit instead of :split
    vim.g.floaterm_opener = 'split'

    -- optional: keymap to launch floaterm
    vim.keymap.set("n", "<leader>v", "<cmd>FloatermNew<CR>", { desc = "Open Floaterm" })
  end
}
