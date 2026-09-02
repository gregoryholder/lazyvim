local GREP_EXCLUDED_DIRS = { "Android/**", "Libs/**" }

local function apply_excluded_dirs(picker)
  local exclude = vim.deepcopy(picker.opts.exclude or {})
  exclude = vim.tbl_filter(function(dir)
    return not vim.tbl_contains(GREP_EXCLUDED_DIRS, dir)
  end, exclude)

  if picker.opts.hide_android_libs ~= false then
    vim.list_extend(exclude, GREP_EXCLUDED_DIRS)
  end

  picker.opts.exclude = exclude
end

local function toggle_excluded_dirs(picker)
  picker.opts.hide_android_libs = not picker.opts.hide_android_libs
  apply_excluded_dirs(picker)
  picker:find()
end

local function grep_to_grug(picker)
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
end

local function grep_picker_keys()
  return {
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
  }
end

local function grep_source(extra)
  return vim.tbl_deep_extend("force", {
    hide_android_libs = false,
    -- exclude = vim.deepcopy(GREP_EXCLUDED_DIRS),
    toggles = {
      hide_android_libs = { icon = "A" },
    },
    win = grep_picker_keys(),
  }, extra or {})
end

return {
  "snacks.nvim",
  keys = {
    { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
  },
  opts = {
    dirs = { "Modules" },
    picker = {
      layout = {
        preview = "main",
        preset = "ivy",
      },
      formatters = {
        file = {
          truncate = 100,
        },
      },
      actions = {
        grep_to_grug = grep_to_grug,
        toggle_excluded_dirs = toggle_excluded_dirs,
      },
      sources = {
        grep = grep_source({
          layout = {
            preview = "main",
            preset = "ivy",
          },
        }),
        grep_word = grep_source({
          layout = {
            layout = {
              width = 0,
            },
          },
        }),
        files = {
          exclude = { "Doc/**", "node_modules/", "ResultatsTestsAuto/" },
          hidden = true,
          ignored = false,
          layout = {
            layout = {
              width = 0,
            },
          },
        },
        explorer = {
          layout = {
            layout = {
              position = "right",
            },
          },
        },
      },
    },
  },
  config = function(_, opts)
    Snacks.picker.util.truncpath = function(path, len, trunc_opts)
      local cwd = svim.fs.normalize(trunc_opts and trunc_opts.cwd or vim.fn.getcwd(), { _fast = true, expand_env = false })
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
        local part_width = vim.api.nvim_strwidth(part)
        if width + part_width > len then
          break
        end
        ret = part .. ret
        width = width + part_width
      end

      return first .. "/…/" .. ret
    end

    Snacks.setup(opts)
  end,
}
