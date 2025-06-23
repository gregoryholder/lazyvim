return {
  "ThePrimeagen/refactoring.nvim",
  opts = {
    print_var_statements = {
      cpp = {
        'mTrace.Dev() << "%s " << %s;',
        'CTrace::System().Dev() << "%s " << %s;'
      }
    },
    printf_statements = {
      cpp = {
        'mTrace.Dev() << "%s";',
        'CTrace::System().Dev() << "%s";'
      }
    }
  }
}
