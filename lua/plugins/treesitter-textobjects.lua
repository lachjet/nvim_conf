-- plugins/treesitter-textobjects.lua
return {
    'nvim-treesitter/nvim-treesitter-textobjects',
    lazy = false,
    config = function()
        require('nvim-treesitter-textobjects').setup {
            select = {
                enable = true,
                keymaps = {
                    ["af"] = { query = "@function.outer",        desc = "Around function" },
                    ["if"] = { query = "@function.inner",        desc = "Inside function" },
                    ["al"] = { query = "@loop.outer",            desc = "Around loop" },
                    ["il"] = { query = "@loop.inner",            desc = "Inside loop" },
                    ["ai"] = { query = "@conditional.outer",     desc = "Around conditional" },
                    ["ii"] = { query = "@conditional.inner",     desc = "Inside conditional" },
                    ["ak"] = { query = "@class.outer",           desc = "Around class" },
                    ["ik"] = { query = "@class.inner",           desc = "Inside class" },
                    ["ae"] = { query = "@parameters.outer",      desc = "Around parameters" },
                    ["ie"] = { query = "@parameters.inner",      desc = "Inside parameters" },
                    ["am"] = { query = "@call.outer",            desc = "Around call" },
                    ["im"] = { query = "@call.inner",            desc = "Inside call" },
                    ["ac"] = { query = "@comment.outer",         desc = "Around comment" },
                    ["ic"] = { query = "@comment.inner",         desc = "Inside comment" },
                },
            },
            move = {
                enable = true,
                set_jumps = true,
                goto_next_start = {
                    ["]f"] = { query = "@function.outer",    desc = "Next function start" },
                    ["]k"] = { query = "@class.outer",       desc = "Next class start" },
                    ["]i"] = { query = "@conditional.outer", desc = "Next conditional start" },
                    ["]l"] = { query = "@loop.outer",        desc = "Next loop start" },
                    ["]m"] = { query = "@call.outer",        desc = "Next call start" },
                    ["]c"] = { query = "@comment.outer",     desc = "Next comment start" },
                },
                goto_previous_start = {
                    ["[f"] = { query = "@function.outer",    desc = "Prev function start" },
                    ["[k"] = { query = "@class.outer",       desc = "Prev class start" },
                    ["[i"] = { query = "@conditional.outer", desc = "Prev conditional start" },
                    ["[l"] = { query = "@loop.outer",        desc = "Prev loop start" },
                    ["[m"] = { query = "@call.outer",        desc = "Prev call start" },
                    ["[c"] = { query = "@comment.outer",     desc = "Prev comment start" },
                },
                goto_next_end = {
                    ["]]f"] = { query = "@function.outer",   desc = "Next function end" },
                    ["]]k"] = { query = "@class.outer",      desc = "Next class end" },
                },
                goto_previous_end = {
                    ["[[f"] = { query = "@function.outer",   desc = "Prev function end" },
                    ["[[k"] = { query = "@class.outer",      desc = "Prev class end" },
                },
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>sp"] = { query = "@parameter.inner", desc = "Swap next parameter" },
                    ["<leader>ss"] = { query = "@statement.outer", desc = "Swap next statement" },
                },
                swap_previous = {
                    ["<leader>sP"] = { query = "@parameter.inner", desc = "Swap previous parameter" },
                    ["<leader>sS"] = { query = "@statement.outer", desc = "Swap previous statement" },
                },
            },
        }
    end,
}
