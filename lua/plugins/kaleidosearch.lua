return {
  "hamidi-dev/kaleidosearch.nvim",
  dependencies = {
    "tpope/vim-repeat",
    "stevearc/dressing.nvim",
  },
  config = function()
    require("kaleidosearch").setup({
      keymaps = {
        enabled = false,
      },
    })
  end,
}
