
local profilepath = vim.fn.stdpath("config") .. "/lua/config/profile.nvim/lua"
vim.opt.rtp:prepend(profilepath)

local should_profile = os.getenv("NVIM_PROFILE")
if should_profile then
  require("profile").instrument_autocmds()
  if should_profile:lower():match("^start") then
    require("profile").start("*")
  else
    require("profile").instrument("*")
  end
end

local function toggle_profile()
  local prof = require("profile")
  if prof.is_recording() then
    prof.stop()
    vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
      if filename then
        prof.export(filename)
        vim.notify(string.format("Wrote %s", filename))
      end
    end)
  else
    prof.start("*")
  end
end
vim.keymap.set("", "<f1>", toggle_profile)

-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

-- local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
-- parser_config.xml_gen = {
--   install_info = {
--     url = "~/workspace/fun/tree-sitter-xml-gen", -- local path or git repo
--     files = {"src/parser.c"}, -- note that some parsers also require src/scanner.c or src/scanner.cc
--     -- optional entries:
--     branch = "main", -- default branch in case of git repo if different from master
--     generate_requires_npm = false, -- if stand-alone parser without npm dependencies
--     requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
--   },
--   filetype = "zu", -- if filetype does not match the parser name
-- }

vim.cmd("set spelllang=fr,en ")
vim.cmd("set noswapfile")

-- require("xml_macro_lsp_helper").setup()
--
package.loaded.xml_delay_inlay = nil
local delay_inlay = require("tae_inlays")
vim.keymap.set("n", "<leader>ue", delay_inlay.toggle_inlays, { desc = "Toggle XML Delay Inlays" })

vim.api.nvim_create_autocmd({ "BufEnter" }, {
  callback = function()
    os.execute("wezterm cli activate-pane")
  end,
})

vim.opt.path:append("Affaires/*/tactileo_ucineo11/mineo/res/")

-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = { 'cpp', 'h' },
--   callback = function() vim.treesitter.start() end,
-- })

-- vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

-- vim.lsp.enable('protols')
--
vim.diagnostic.config({
  virtual_text = {
    source = true,
    format = function(diagnostic)
      if diagnostic.user_data and diagnostic.user_data.code then
        return string.format("%s %s", diagnostic.user_data.code, diagnostic.message)
      else
        return diagnostic.message
      end
    end,
  },
  signs = true,
  float = {
    header = "Diagnostics",
    source = true,
    border = "rounded",
  },
})
