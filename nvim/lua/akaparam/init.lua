require("akaparam.set")
require("akaparam.remap")
require("akaparam.lazy_init")

local create_augroup = vim.api.nvim_create_augroup
local create_autocmd = vim.api.nvim_create_autocmd

local editor_config_group = create_augroup("EditorConfig", {})
local yank_highlight_group = create_augroup("YankHighlight", {})

function ReloadModule(module_name)
    require("plenary.reload").reload_module(module_name)
end

vim.filetype.add({
    extension = {
        templ = "templ",
    },
})

create_autocmd("TextYankPost", {
    group = yank_highlight_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 40,
        })
    end,
})

create_autocmd("BufWritePre", {
    group = editor_config_group,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

create_autocmd("BufEnter", {
    group = editor_config_group,
    callback = function()
        local zig_colorscheme = "tokyonight-night"
        local default_colorscheme = "rose-pine-moon"

        if vim.bo.filetype == "zig" then
            pcall(vim.cmd.colorscheme, zig_colorscheme)
        else
            pcall(vim.cmd.colorscheme, default_colorscheme)
        end
    end,
})

create_autocmd("LspAttach", {
    group = editor_config_group,
    callback = function(event)
        local buffer_keymap_options = { buffer = event.buf }

        vim.keymap.set("n", "gd", vim.lsp.buf.definition, buffer_keymap_options)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, buffer_keymap_options)
        vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, buffer_keymap_options)
        vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, buffer_keymap_options)
        vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, buffer_keymap_options)
        vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, buffer_keymap_options)
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, buffer_keymap_options)
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, buffer_keymap_options)
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, buffer_keymap_options)
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, buffer_keymap_options)
    end,
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25