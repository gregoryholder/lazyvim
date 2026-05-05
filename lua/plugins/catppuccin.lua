return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    dim_inactive = {
      enabled = true,
    },
    styles = {
      comments = {},
    },
    custom_highlights = function(colors)
      return {
        WinSeparator = { fg = colors.flamingo },
      }
    end,
  },
}
