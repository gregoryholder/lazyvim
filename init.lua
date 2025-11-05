-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.cmd("set spelllang=fr,en ")
vim.cmd("set noswapfile")

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    os.execute("wezterm cli activate-pane")
  end,
})
