return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

        local create_augroup = vim.api.nvim_create_augroup
        local create_autocmd = vim.api.nvim_create_autocmd

        local fugitive_group = create_augroup("FugitiveGitWorkflow", {})

        create_autocmd("BufWinEnter", {
            group = fugitive_group,
            pattern = "*",
            callback = function()
                if vim.bo.filetype ~= "fugitive" then
                    return
                end

                local current_buffer = vim.api.nvim_get_current_buf()
                local buffer_keymap_options = {
                    buffer = current_buffer,
                    remap = false,
                }

                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git("push")
                end, buffer_keymap_options)

                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git({ "pull", "--rebase" })
                end, buffer_keymap_options)

                vim.keymap.set(
                    "n",
                    "<leader>t",
                    ":Git push -u origin ",
                    buffer_keymap_options
                )
            end,
        })

        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
    end,
}