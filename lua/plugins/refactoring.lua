return {
  "ThePrimeagen/refactoring.nvim",
  opts = {
    print_var_statements = {
      cpp = {
        'CTrace::System().Dev() << "%s " << %s;',
        'mTrace.Dev() << "%s " << %s;',
      },
    },
    printf_statements = {
      cpp = {
        'CTrace::System().Dev() << "%s";',
        'mTrace.Dev() << "%s";',
      },
    },
  },
  keys = {
    {
      "<leader>rP",
      function()
        require("refactoring").debug.printf({ below = false })
      end,
      desc = "Debug Print",
      mode = {"n", "x"},
    },
    {
      "<leader>rp",
      function()
        require("refactoring").debug.print_var({ normal = true })
      end,
      desc = "Debug Print Variable",
      mode = {"n", "x"},
    },
    {
      "<leader>rr",
      function()
        require("refactoring").select_refactor()
      end,
      desc = "Pick",
      mode = {"n", "x"},
    },
  },
}
