return {
  { "tiagovla/scope.nvim", config = true },
  -- {
  --   "m4xshen/hardtime.nvim",
  --   lazy = false,
  --   dependencies = { "MunifTanjim/nui.nvim" },
  --   opts = {
  --     disable_mouse = false,
  --     hints = {
  --       ["[dcyvV][ia][%(%)]"] = {
  --         message = function(keys)
  --           return "Use " .. keys:sub(1, 2) .. "b instead of " .. keys
  --         end,
  --         length = 3,
  --       },
  --       ["[dcyvV][ia][%{%}]"] = {
  --         message = function(keys)
  --           return "Use " .. keys:sub(1, 2) .. "B instead of " .. keys
  --         end,
  --         length = 3,
  --       },
  --     },
  --   },
  -- },
  {
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
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  }
}
