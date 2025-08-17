-- ~/.config/nvim/lua/custom/switcher.lua
local M = {}

function M.dispatch_switch()
  local ft = vim.bo.filetype

  if ft == "cpp" or ft == "c" or ft == "objc" then
    vim.cmd("ClangdSwitchSourceHeader")
  else
    M.smart_cycle()
  end
end

function M.smart_cycle()
  local current = vim.api.nvim_buf_get_name(0)
  local base = current:gsub("%.cfglocale%.xml$", "")
                     :gsub("%.before%.py$", "")
                     :gsub("%.xml$", "")
                     :gsub("%.py$", "") -- fallback

  local cycle = {
    base .. ".xml",
    base .. ".cfglocale.xml",
    base .. ".before.py",
  }

  -- Find current position in cycle
  local current_index = nil
  for i, path in ipairs(cycle) do
    if current == path then
      current_index = i
      break
    end
  end

  -- Try next available file in cycle
  for offset = 1, #cycle - 1 do
    local next_index = ((current_index or 0) + offset - 1) % #cycle + 1
    local target = cycle[next_index]
    -- if vim.fn.filereadable(target) == 1 then
    vim.cmd("edit " .. target)
      -- return
    -- end
  end

  print("No other file in cycle found.")
end

return M
