vim.cmd("set number");
vim.cmd("set autoindent");
vim.cmd("set tabstop=4");
vim.cmd("set shiftwidth=4");
vim.cmd("set smarttab");
vim.cmd("set softtabstop=4");
vim.cmd("set mouse=a");
vim.cmd("set rnu");


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
