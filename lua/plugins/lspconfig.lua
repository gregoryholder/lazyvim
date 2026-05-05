return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      neocmake = {
        init_options = {
          lint = {},
        },
        settings = {
          line_max_words = 200,
        },
      },
      rust_analyzer = {
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              targetDir = true,
            },
          },
        },
      },
      protols = {},
      clangd = {
        cmd = {
          "clangd",
          "-j=12",
          "--malloc-trim",
          "--background-index",
          "--pch-storage=memory",
          "--clang-tidy",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
          "--header-insertion=never",
        },
      },
    },
  },
}
