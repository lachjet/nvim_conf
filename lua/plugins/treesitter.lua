return {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    dependencies = { 'nvim-treesitter/nvim-treesitter-textobjects' },
    config = function()
        -- Minimal setup - just set install dir (optional, this is the default)
        require('nvim-treesitter').setup {
            install_dir = vim.fn.stdpath('data') .. '/site'
        }

        -- Install parsers
        require('nvim-treesitter').install({
            "c", "cpp", "lua", "vim", "vimdoc", "javascript", "typescript",
            "python", "html", "css", "json", "yaml", "markdown", "rust",
            "go", "java", "cmake", "query"
        })

        -- Highlighting, indents etc. are now enabled via vim.treesitter directly
        vim.treesitter.language.register('markdown', 'mdx')

        -- Textobjects are configured in the textobjects plugin spec now
        vim.api.nvim_set_hl(0, "@comment", { fg = "#00CC00", italic = true })
    end,
}
