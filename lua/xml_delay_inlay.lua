local M = {}

local ns_id = vim.api.nvim_create_namespace("xml_delay_inlays")
local enabled = false

local function show_inlays()
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local accumulated = 0

  for line_num, line in ipairs(lines) do
    local delay_str = line:match('<r%s+delay="(%d+)"%s*/>')
    local time_str = line:match('<r%s+time="(%d+)"%s*/>')

    local hint = nil

    if delay_str then
      local delay = tonumber(delay_str) or 0
      accumulated = accumulated + delay
      hint = " [" .. accumulated .. "ms]"
    elseif time_str then
      accumulated = tonumber(time_str) or 0
      hint = " [" .. accumulated .. "ms]"
    end

    if hint then
      vim.api.nvim_buf_set_extmark(0, ns_id, line_num - 1, #line, {
        virt_text = { { hint, "Comment" } },
        virt_text_pos = "inline",
      })
    end

    -- local matches = line:gmatch('"([0-9a-fA-F]+)"')
    -- for m in matches do
    --   vim.print(m)
    -- end
    local line_offset = 1

    while true do
      local match_start, match_end = string.find(line, '"([0-9a-fA-F]+)"', line_offset)
      if match_start == nil then
        break
      end

      local start_pos = match_start

      local hex_str = line:sub(match_start + 1, match_end - 1)

      local cursor = vim.api.nvim_win_get_cursor(0)
      local row, col = cursor[1], cursor[2]

      local ascii = {}
      for i = 1, #hex_str, 2 do
        local byte = tonumber(hex_str:sub(i, i + 1), 16)
        if byte >= 32 and byte <= 127 then
          ascii[#ascii + 1] = string.char(byte)
        else
          ascii[#ascii + 1] = "."
        end
      end

      local byte_index = math.floor((col - start_pos) / 2) + 1
      if byte_index >= 1 and byte_index <= #ascii and row == line_num then
        local before = table.concat(ascii, "", 1, byte_index - 1)
        local highlight = ascii[byte_index] or ""
        local after = table.concat(ascii, "", byte_index + 1)
        vim.api.nvim_buf_set_extmark(0, ns_id, line_num - 1, #line, {
          virt_text = {
            { " [" .. before, "Comment" },
            { highlight, "WarningMsg" },
            { after .. "] ", "Comment" },
          },
          virt_text_pos = "inline",
        })
      else
        vim.api.nvim_buf_set_extmark(0, ns_id, line_num - 1, #line, {
          virt_text = {
            { " [" .. table.concat(ascii, "", 1) .. "] ", "Comment" },
          },
          virt_text_pos = "inline",
        })
        -- end
      end
      line_offset = match_end + 1
    end
  end
end

function M.toggle_inlays()
  enabled = not enabled
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

  if enabled then
    show_inlays()
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufWritePost", "CursorMoved" }, {
      group = vim.api.nvim_create_augroup("XmlDelayInlays", { clear = true }),
      callback = function()
        show_inlays()
      end,
      buffer = 0,
    })
  else
    vim.api.nvim_clear_autocmds({ group = "XmlDelayInlays", buffer = 0 })
  end
end

return M
