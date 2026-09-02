return {
  "ergodice/hamal.nvim",
  config = function()
    local hamal = require("hamal")

    vim.keymap.set("n", "<leader>k", hamal.split, { desc = "Hamal split" })
    vim.keymap.set("o", "<leader>k", hamal.split, { desc = "Hamal split" })

    hamal.setup({
      highlights = {
        section = {
          { "HamalSectionOne", { bg = "#313244", fg = "#cdd6f4" } },
          { "HamalSectionTwo", { bg = "#45475a", fg = "#f5e0dc" } },
          { "HamalSectionThree", { bg = "#585b70", fg = "#cba6f7" } },
        },
        line = {
          { "HamalLine", { bg = "#1e1e2e", fg = "#fab387" } },
        },
      },
    })
  end,
}
