
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

local nvim_fnm_node_version = vim.env.NVIM_FNM_NODE_VERSION or "22"
if vim.fn.executable("fnm") == 1 then
  local node_path = vim.trim(vim.fn.system({
    "fnm",
    "exec",
    "--using=" .. nvim_fnm_node_version,
    "--",
    "node",
    "-p",
    "process.execPath",
  }))
  if vim.v.shell_error == 0 and vim.fn.executable(node_path) == 1 then
    local nvim_node_bin = vim.fn.fnamemodify(node_path, ":h")
    vim.env.PATH = nvim_node_bin .. ":" .. vim.env.PATH
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
-- require("snacks").toggle.option()
vim.keymap.set("n", "<leader>ue", delay_inlay.toggle_inlays, { desc = "Toggle XML Delay Inlays" })

-- vim.api.nvim_create_autocmd({ "BufEnter" }, {
--   callback = function()
--     os.execute("wezterm cli activate-pane")
--   end,
-- })

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
vim.o.clipboard = 'unnamedplus'

-- Highlight trailing whitespace (only in writable buffers)
vim.api.nvim_set_hl(0, "TrailingWhitespace", { bg = "#AF00FF", fg = "#FFFFFF" })
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile", "InsertLeave" }, {
  callback = function()
    -- if vim.bo.modifiable then
    --   vim.fn.matchadd("TrailingWhitespace", "\\s\\+$", -1)
    -- end
  end,
})

-- -- Highlight invalid leading indentation (not a multiple of 3 spaces)
-- vim.api.nvim_set_hl(0, "BadIndent", { bg = "#FF005F", fg = "#FFFFFF" })
-- vim.api.nvim_create_autocmd({ "FileType", "BufRead", "BufNewFile" }, {
--   pattern = { "cpp", "CfgEmbarqueVEH_generique.xml" },
--   callback = function()
--     if vim.bo.modifiable then
--       -- Leading spaces where count % 3 ~= 0
--       vim.fn.matchadd("BadIndent", [[^\%( \{3}\)*\%( \{1,2}\)\ze\S]], -1)
--     end
--   end,
-- })

-- Strip trailing whitespace command
local function strip_trailing_whitespace(opts)
  local confirm = opts.args == "-confirm"
  local start_line = opts.line1
  local end_line = opts.line2
  
  local cmd = string.format("%d,%ds/\\s\\+$//e%s", start_line, end_line, confirm and "c" or "")
  vim.cmd(cmd)
end

vim.api.nvim_create_user_command("StripTrailingWhitespace", strip_trailing_whitespace, {
  nargs = "?",
  range = "%",
  complete = function(arg_lead, cmd_line, cursor_pos)
    if arg_lead:match("^-") then
      return { "-confirm" }
    end
    return {}
  end,
})

vim.api.nvim_create_user_command("LspSwitch", function(opts)
  local program = opts.fargs[1] or "vehicule"
  -- Define your mapping from program to compile_commands.json path
  local paths = {
    vehicule = "TargetLinuxHost/VehiculeUnityBuildsDebug/compile_commands.json",
    borne = "TargetLinuxHost/BorneUnityBuildsDebug/compile_commands.json",
    icc = "/path/to/icc/compile_commands.json",
  }
  local target_path = paths[program]
  if not target_path then
    print("Unknown program: " .. program)
    return
  end
  -- Update symlink (adjust destination as needed)
  os.execute("ln -sf " .. target_path .. " compile_commands.json")
  -- Restart clangd
  vim.cmd("lsp restart")
  print("Switched to " .. program)
end, {
  nargs = '?',
  complete = function(_, line)
    local items = { "vehicule", "borne", "icc" }
    return vim.tbl_filter(function(item)
        return item:find(vim.fn.expandcmd(line:match("%S+$") or ""), 1, true)
    end, items)
  end,
})

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
-- vim.schedule(function()
--   vim.o.clipboard:append('unnamedplus')
--
--   -- Fix "waiting for osc52 response from terminal" message
--   -- https://github.com/neovim/neovim/issues/28611
--
--   if vim.env.SSH_TTY ~= nil then
--     -- Set up clipboard for ssh
--
--     local function my_paste(_)
--       return function(_)
--         local content = vim.fn.getreg('"')
--         return vim.split(content, '\n')
--       end
--     end
--
-- vim.g.clipboard = {
--   name = 'OSC 52',
--   copy = {
--     ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
--     ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
--   },
--   paste = {
--     -- No OSC52 paste action since wezterm doesn't support it
--     -- Should still paste from nvim
--     ['+'] = function () end,
--     ['*'] = function () end,
--   },
-- }

vim.g.root_spec = { { ".git", "lua" }, "cwd" }
--   end
-- end)
