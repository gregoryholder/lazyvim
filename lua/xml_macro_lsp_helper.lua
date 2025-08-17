-- File: lua/xml_macro_lsp_helper.lua

local M = {}

-- Customize your active macros here
local active_macros = {
  AFFAIRE_NORAM = true,
}

local ns = vim.api.nvim_create_namespace("inactive_region_dimming")

-- Highlight group
vim.api.nvim_set_hl(0, "InactiveRegion", { fg = "#888888", italic = true })

-- Dim inactive blocks
function M.dim_inactive(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

  local stack = {}
  for i, line in ipairs(lines) do
    local if_macro = line:match("^#IF#%s+(%S+)")
    local endif_macro = line:match("^#ENDIF#%s+(%S+)")

    if if_macro then
      table.insert(stack, { macro = if_macro, start = i - 1 })
    elseif endif_macro and #stack > 0 then
      local last = table.remove(stack)
      if last.macro == endif_macro and not active_macros[endif_macro] then
        for j = last.start, i - 1 do
          vim.api.nvim_buf_add_highlight(bufnr, ns, "InactiveRegion", j, 0, -1)
        end
      end
    end
  end
end

-- Return all lines, replacing inactive lines with empty lines, and track which are active
local function get_filtered_lines_with_blanks_and_map(bufnr)
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local result = {}
  local mapping = {}
  local active = true
  local stack = {}

  for i, line in ipairs(lines) do
    local if_macro = line:match("^#IF#%s+(%S+)")
    local endif_macro = line:match("^#ENDIF#%s+(%S+)")
    local def_macro = line:match("^#DEF#%s+%S+%s+%S+")
    local comment = line:match("^#") and not line:match("^#IF#") and not line:match("^#ENDIF#") and not line:match("^#DEF#")

    if if_macro then
      table.insert(stack, active)
      active = active_macros[if_macro] or false
      table.insert(result, "")
      table.insert(mapping, { line = i - 1, active = false })
    elseif endif_macro then
      active = table.remove(stack) or true
      table.insert(result, "")
      table.insert(mapping, { line = i - 1, active = false })
    elseif def_macro or comment then
      -- Wrap macro defs and plain #comments in XML comment
      table.insert(result, string.format("<!-- %s -->", line))
      table.insert(mapping, { line = i - 1, active = true })
    elseif active then
      table.insert(result, line)
      table.insert(mapping, { line = i - 1, active = true })
    else
      table.insert(result, "")
      table.insert(mapping, { line = i - 1, active = false })
    end
  end

  return result, mapping
end

-- Create a virtual buffer with sync enabled
function M.create_virtual_xml_buf()
  local original_buf = vim.api.nvim_get_current_buf()
  local lines, mapping = get_filtered_lines_with_blanks_and_map(original_buf)

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_option(buf, 'filetype', 'xml')
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Open in vertical split for inspection
  vim.cmd("vsplit")
  vim.api.nvim_win_set_buf(0, buf)

  -- Track changes and sync back
  vim.api.nvim_create_autocmd("TextChanged", {
    buffer = buf,
    callback = function()
      local new_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
      for i, entry in ipairs(mapping) do
        if entry.active then
          local new_line = new_lines[i]
          vim.api.nvim_buf_set_lines(original_buf, entry.line, entry.line + 1, false, { new_line })
        end
      end
    end,
  })

  -- Attach XML LSP if available (e.g., lemminx)
  require('lspconfig').lemminx.manager.try_add_wrapper(buf)
end

-- Setup autocmds
function M.setup()
  vim.api.nvim_create_autocmd({"BufReadPost", "BufWritePost"}, {
    pattern = {"*.xconf", "*.myxml"},
    callback = function(args)
      M.dim_inactive(args.buf)
    end
  })

  -- Command to open filtered buffer
  vim.api.nvim_create_user_command("XmlFilterActive", function()
    M.create_virtual_xml_buf()
  end, {})
end

return M
