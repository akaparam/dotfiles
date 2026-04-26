return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        lazy = false,
        init = function()
            local treesitter_parsers = {
                "lua",
                "vim",
                "vimdoc",
                "query",
                "javascript",
                "typescript",
                "tsx",
                "html",
                "css",
                "json",
                "gitignore",
                "go",
            }

            local create_augroup = vim.api.nvim_create_augroup
            local create_autocmd = vim.api.nvim_create_autocmd

            local treesitter_group = create_augroup("TreesitterConfiguration", {
                clear = true,
            })

            create_autocmd({ "BufEnter", "FileType" }, {
                group = treesitter_group,
                callback = function()
                    local is_regular_buffer = vim.bo.buftype == ""

                    if not is_regular_buffer then
                        return
                    end

                    pcall(vim.treesitter.start, 0)
                end,
            })

            create_autocmd("User", {
                group = treesitter_group,
                pattern = "VeryLazy",
                once = true,
                callback = function()
                    require("nvim-treesitter").install(treesitter_parsers)
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        lazy = false,
        config = function()
            local textobjects = require("nvim-treesitter-textobjects")

            textobjects.setup({
                select = {
                    enable = true,
                    lookahead = true,
                    keymaps = {
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                    },
                },
            })
        end,
    },
}