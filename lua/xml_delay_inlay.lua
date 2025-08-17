local M = {}

local ns_id = vim.api.nvim_create_namespace("xml_delay_inlays")
local enabled = false

local function show_inlays()
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local accumulated = 0

  for i, line in ipairs(lines) do
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
      vim.api.nvim_buf_set_extmark(0, ns_id, i - 1, #line, {
        virt_text = { { hint, "Comment" } },
        virt_text_pos = "inline",
      })
    end
  end
end

function M.toggle_inlays()
  enabled = not enabled
  vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)

  if enabled then
    show_inlays()
    vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI", "BufWritePost" }, {
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
