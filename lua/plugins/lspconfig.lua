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
          "-j=24",
          -- "--malloc-trim",
          "--background-index",
          -- "--pch-storage=memory",
          "--clang-tidy",
          -- "--completion-style=detailed",
          -- "--function-arg-placeholders",
          -- "--fallback-style=llvm",
          "--header-insertion=never",
        },
      },
      vtsls = {
        handlers = {
          ["textDocument/publishDiagnostics"] = function(_, result, ctx)
            if result.diagnostics then
              result.diagnostics = vim.tbl_filter(function(d)
                return d.code ~= 80001
              end, result.diagnostics)
            end

            vim.lsp.diagnostic.on_publish_diagnostics(
              nil,
              result,
              ctx
            )
          end,
        },
      },
    },
  },
}
