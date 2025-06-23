-- ~/.config/nvim/lua/custom/switcher.lua
local M = {}

function M.dispatch_switch()
  local ft = vim.bo.filetype

  if ft == "cpp" or ft == "c" or ft == "objc" then
    -- Use built-in Clangd switch
    vim.cmd("ClangdSwitchSourceHeader")
  elseif ft == "xml" then
    M.switch_xml_cfglocale()
  else
    print("No switch behavior defined for filetype: " .. ft)
  end
end

function M.switch_xml_cfglocale()
  local current = vim.api.nvim_buf_get_name(0)
  local target = nil

  if current:match("%.cfglocale%.xml$") then
    target = current:gsub("%.cfglocale%.xml$", ".xml")
  elseif current:match("%.xml$") then
    target = current:gsub("%.xml$", ".cfglocale.xml")
  end

  if target and vim.fn.filereadable(target) == 1 then
    vim.cmd("edit " .. target)
  else
    print("No corresponding file found: " .. (target or "unknown"))
  end
end

return M
