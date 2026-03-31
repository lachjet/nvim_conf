vim.cmd("set number");
vim.cmd("set autoindent");
vim.cmd("set tabstop=4");
vim.cmd("set shiftwidth=4");
vim.cmd("set smarttab");
vim.cmd("set softtabstop=4");
vim.cmd("set mouse=a");
vim.cmd("set rnu");

vim.o.modeline = false
vim.o.modelines = 0


vim.cmd("highlight LineNr       guifg=#5c6370 guibg=NONE")
vim.cmd("highlight CursorLineNr guifg=#98c379 guibg=NONE")

vim.g.clipboard = {
	name = "xsel",
    copy = {
        ["+"] = "xsel --nodetach -ib",
        ["*"] = "xsel --nodetach -ip"
    },
    paste = {
        ["+"] = "xsel -ob",
        ["*"] = "xsel -op"
    },
    cache_enabled = true,
}
vim.opt.clipboard = ""
