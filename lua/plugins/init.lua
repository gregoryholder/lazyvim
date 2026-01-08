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
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        rust = { "rustfmt", lsp_format = "fallback" },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    opts = {
      enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
      multiwindow = true, -- Enable multiwindow support.
      max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
      min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
      line_numbers = true,
      multiline_threshold = 20, -- Maximum number of lines to show for a single context
      trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
      mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
      -- Separator between context and content. Should be a single character string, like '-'.
      -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
      separator = nil,
      zindex = 20, -- The Z-index of the context window
      on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
    },
  },
  { "simonefranza/nvim-conv" },
  { "sindrets/diffview.nvim" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- jinja_lsp = {
        --   filetypes = { 'jinja', 'rust', 'python' },
        --   templates = { "Affaires", "Affaires/templates"},
        --   backend = {"."},
        --   lang = "python",
        --   hide_undefined = false,
        -- },
        rust_analyzer = {},
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
  },
  -- {
  --   "letieu/wezterm-move.nvim",
  --   keys = { -- Lazy loading, don't need call setup() function
  --     { "<C-h>", function() require("wezterm-move").move "h" end },
  --     { "<C-j>", function() require("wezterm-move").move "j" end },
  --     { "<C-k>", function() require("wezterm-move").move "k" end },
  --     { "<C-l>", function() require("wezterm-move").move "l" end },
  --   },
  -- }
  {
    "kylechui/nvim-surround",
    version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup({
        -- Configuration here, or leave empty to use defaults
      })
    end,
  },
  {
    "johmsalas/text-case.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("textcase").setup({})
      require("telescope").load_extension("textcase")
    end,
    keys = {
      "ga", -- Default invocation prefix
      { "ga.", "<cmd>TextCaseOpenTelescope<CR>", mode = { "n", "x" }, desc = "Telescope" },
    },
    cmd = {
      -- NOTE: The Subs command name can be customized via the option "substitude_command_name"
      "Subs",
      "TextCaseOpenTelescope",
      "TextCaseOpenTelescopeQuickChange",
      "TextCaseOpenTelescopeLSPChange",
      "TextCaseStartReplacingCommand",
    },
    -- If you want to use the interactive feature of the `Subs` command right away, text-case.nvim
    -- has to be loaded on startup. Otherwise, the interactive feature of the `Subs` will only be
    -- available after the first executing of it or after a keymap of text-case.nvim has been used.
    lazy = false,
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        markdownlint = {
          args = { "--disable", "MD013", "--" },
        },
      },
    },
  },
  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n", "x", "o", false } },
      { "S", mode = { "n", "x", "o", false } },
    },
  },
  -- {
  --   "hamidi-dev/kaleidosearch.nvim",
  --   dependencies = {
  --     "tpope/vim-repeat",       -- optional for dot-repeatability
  --     "stevearc/dressing.nvim", -- optional for nice input
  --   },
  --   config = function()
  --     require("kaleidosearch").setup({
  --       -- optional configuration
  --     })
  --   end,
  -- },
  {
    "danymat/neogen",
    -- config = true,
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
    opts = function(_)
      local i = require("neogen.types.template").item
      return {
        languages = {
          cpp = {
            template = {
              doxygen = {
                { nil, "/**", { no_results = true, type = { "func", "file", "class" } } },
                { nil, " * @file", { no_results = true, type = { "file" } } },
                { nil, " * @brief $1", { no_results = true, type = { "func", "file", "class" } } },
                { nil, " */", { no_results = true, type = { "func", "file", "class" } } },
                { nil, "", { no_results = true, type = { "file" } } },

                { nil, "/**", { type = { "func", "class", "type" } } },
                { i.ClassName, " * @class %s", { type = { "class" } } },
                { i.Type, " * @typedef %s", { type = { "type" } } },
                { nil, " * @brief $1", { type = { "func", "class", "type" } } },
                { nil, " *", { type = { "func", "class", "type" } } },
                { i.Tparam, " * @tparam %s $1" },
                { i.Parameter, " * @param[in] %s $1" },
                { i.Return, " * @return $1" },
                { nil, " */", { type = { "func", "class", "type" } } },
              },
            },
          },
        },
      }
    end,
  },
  {
    "MagicDuck/grug-far.nvim",
    opts = {
      engines = {
        ripgrep = {
          defaults = {
            flags = "-S",
          },
        },
      },
    },
  },
  {
    "hat0uma/csvview.nvim",
    ---@module "csvview"
    ---@type CsvView.Options
    opts = {
      view = {
        header_lnum = 2,
        display_mode = "border",
      },
      parser = {
        comments = { "#", "//" },
        delimiter = {
          ft = {
            csv = ";",
          },
        },
      },
      keymaps = {
        -- Text objects for selecting fields
        textobject_field_inner = { "if", mode = { "o", "x" } },
        textobject_field_outer = { "af", mode = { "o", "x" } },
        -- Excel-like navigation:
        -- Use <Tab> and <S-Tab> to move horizontally between fields.
        -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
        -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
        jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
        jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
        jump_next_row = { "<Enter>", mode = { "n", "v" } },
        jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
      },
    },
    cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },
  },
  { "jokajak/keyseer.nvim", version = false },
  -- {
  --     'jmattaa/regedit.vim'
  {
    "garymjr/nvim-snippets",
    opts = {
      -- create_autocmd = true
      -- create_cmp_source = false
    },
    keys = {
      {
        "<Tab>",
        function()
          if vim.snippet.active({ direction = 1 }) then
            vim.schedule(function()
              vim.snippet.jump(1)
            end)
            return
          end
          return "<Tab>"
        end,
        expr = true,
        silent = true,
        mode = "i",
      },
      {
        "<Tab>",
        function()
          vim.schedule(function()
            vim.snippet.jump(1)
          end)
        end,
        expr = true,
        silent = true,
        mode = "s",
      },
      {
        "<S-Tab>",
        function()
          if vim.snippet.active({ direction = -1 }) then
            vim.schedule(function()
              vim.snippet.jump(-1)
            end)
            return
          end
          return "<S-Tab>"
        end,
        expr = true,
        silent = true,
        mode = { "i", "s" },
      },
    },
  }, -- }
  {
    "esmuellert/vscode-diff.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    cmd = "CodeDiff",
  }
}
