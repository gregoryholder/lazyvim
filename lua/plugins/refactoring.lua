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
}
