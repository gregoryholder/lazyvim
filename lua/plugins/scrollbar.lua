return {
  "petertriho/nvim-scrollbar",

  config = function(_, opts)
    require("scrollbar").setup()
    require("scrollbar.handlers.gitsigns").setup()
  end
}
