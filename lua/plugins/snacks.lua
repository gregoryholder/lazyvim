local grep_excluded_dirs = { "Android/**", "Libs/**" }

local function apply_excluded_dirs(picker)
  local exclude = vim.deepcopy(picker.opts.exclude or {})
  exclude = vim.tbl_filter(function(dir)
    return not vim.tbl_contains(grep_excluded_dirs, dir)
  end, exclude)

  if picker.opts.hide_android_libs ~= false then
    for _, dir in ipairs(grep_excluded_dirs) do
      table.insert(exclude, dir)
    end
  end

  picker.opts.exclude = exclude
end

local function toggle_excluded_dirs(picker)
  picker.opts.hide_android_libs = not picker.opts.hide_android_libs
  apply_excluded_dirs(picker)
  picker:find()
end

return {
  "snacks.nvim",
  keys = {
    -- { "<leader>ps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Bufer" },
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
      actions = {
        grep_to_grug = function(picker)
          local search = vim.trim(picker.input.filter.search or "")
          if search == "" then
            Snacks.notify.warn("No grep search to send to grug-far", { title = "Snacks Picker" })
            return
          end
          picker:close()
          require("grug-far").open({
            prefills = {
              search = search,
              paths = picker:cwd(),
            },
          })
        end,
        toggle_excluded_dirs = function(picker)
          toggle_excluded_dirs(picker)
        end,
      },
 -- lua Snacks.picker.grep({dirs = {"Modules"}})
      sources = {
        grep = {
          hide_android_libs = true,
          exclude = { "Android/**", "Libs/**" },
          toggles = {
            hide_android_libs = { icon = "A" },
          },
          win = {
            input = {
              keys = {
                ["<C-g>"] = { "grep_to_grug", mode = { "n", "i" } },
                ["<A-e>"] = { "toggle_excluded_dirs", mode = { "n", "i" } },
              },
            },
            list = {
              keys = {
                ["<C-g>"] = { "grep_to_grug", mode = { "n", "x" } },
                ["<A-e>"] = { "toggle_excluded_dirs", mode = { "n", "x" } },
              },
            },
          },
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
          hide_android_libs = true,
          exclude = { "Android/**", "Libs/**" },
          toggles = {
            hide_android_libs = { icon = "A" },
          },
          win = {
            input = {
              keys = {
                ["<C-g>"] = { "grep_to_grug", mode = { "n", "i" } },
                ["<A-e>"] = { "toggle_excluded_dirs", mode = { "n", "i" } },
              },
            },
            list = {
              keys = {
                ["<C-g>"] = { "grep_to_grug", mode = { "n", "x" } },
                ["<A-e>"] = { "toggle_excluded_dirs", mode = { "n", "x" } },
              },
            },
          },
          layout = {
            layout = {
              width = 0
            }
          },
        },
        files = {
          exclude = {"Doc/**", "node_modules/", "ResultatsTestsAuto/"},
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
    -- Snacks.toggle.profiler():map("<leader>pp")
    -- Toggle the profiler highlights
    -- Snacks.toggle.profiler_highlights():map("<leader>ph")

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
