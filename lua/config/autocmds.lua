-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
--

-- Disable autoformat for lua files
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "xml" },
  callback = function()
    vim.b.autoformat = false
    vim.bo.indentexpr = ""
  end,
})

vim.api.nvim_create_autocmd({"BufEnter"}, {
  pattern = {"config.txt"},
  callback = function()
    vim.b.filetype = "sh"
  end
})
