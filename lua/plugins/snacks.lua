return {
  "snacks.nvim",
  keys = {
    { "<leader>ps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Bufer" },
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
  },
  opts = {
    dirs = {"Modules"},
    picker  = {
      layout = {
        preview = "main",
        preset = "ivy",
      },
      -- win = {
      --   input = {
      --     keys = {
      --       ["<c-j>"] = {},
      --       ["<c-k>"] = {},
      --     }
      --   },
      --   list = {
      --     ["<c-j>"] = {},
      --     ["<c-k>"] = {},
      --   }
      -- },
      util = {
        truncpath = function(path, len, opts)
            return "test"
        end
      },
      formatters = {
        file = {
          truncate = 100
        },
      },
-- lua Snacks.picker.grep({dirs = {"Modules"}})
      sources = {
        grep = {
          -- auto_close = false,
          -- jump = {
          --   close = false
          -- },
          -- dirs = {"Modules"},
          layout = {
            preview = "main",
            preset = "ivy",
            -- layout = {
            --   width = 0
            -- }
          },
        },
        grep_word = {
          layout = {
            layout = {
              width = 0
            }
          },
        },
        files = {
          hidden = true,
          ignored = true,
          layout = {
            layout = {
              width = 0
            }
          },
        },
        explorer = {
          -- replace_netrw = false,
          layout = {
            layout = {
              position = "right"
            }
          }
        }
      }
    }
  },
  config = function(_, opts)
    -- Toggle the profiler
    Snacks.toggle.profiler():map("<leader>pp")
    -- Toggle the profiler highlights
    Snacks.toggle.profiler_highlights():map("<leader>ph")

    original_truncpath = Snacks.picker.util.truncpath
    Snacks.picker.util.truncpath = function(path, len, opts)
      local cwd = svim.fs.normalize(opts and opts.cwd or vim.fn.getcwd(), { _fast = true, expand_env = false })
      local home = svim.fs.normalize("~")
      path = svim.fs.normalize(path, { _fast = true, expand_env = false })

      if path:find(cwd .. "/", 1, true) == 1 and #path > #cwd then
        path = path:sub(#cwd + 2)
      else
        local root = Snacks.git.get_root(path)
        if root and root ~= "" and path:find(root, 1, true) == 1 then
          local tail = vim.fn.fnamemodify(root, ":t")
          path = "⋮" .. tail .. "/" .. path:sub(#root + 2)
        elseif path:find(home, 1, true) == 1 then
          path = "~" .. path:sub(#home + 1)
        end
      end
      path = path:gsub("/$", "")
      path = path:gsub("Affaires/", "…/")
      path = path:gsub("vehicule_host/", "…/")
      path = path:gsub("TestsAuto/", "…/")

      if vim.api.nvim_strwidth(path) <= len then
        return path
      end

      local parts = vim.split(path, "/")
      if #parts < 2 then
        return path
      end
      local ret = table.remove(parts)
      local first = table.remove(parts, 1)
      if first == "~" and #parts > 0 then
        first = "~/" .. table.remove(parts, 1)
      end
      local width = vim.api.nvim_strwidth(ret) + vim.api.nvim_strwidth(first) + 3
      while width < len and #parts > 0 do
        local part = table.remove(parts) .. "/"
        local w = vim.api.nvim_strwidth(part)
        if width + w > len then
          break
        end
        ret = part .. ret
        width = width + w
      end
      return first .. "/…/" .. ret
    end
    Snacks.setup(opts)
  end
}
