return {
  "lewis6991/gitsigns.nvim",
  config = function(_, opts)
    require('gitsigns').setup(opts)
    -- require("scrollbar.handlers.gitsigns").setup()
  end
}
