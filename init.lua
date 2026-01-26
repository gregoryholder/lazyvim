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


-- vim.lsp.enable('protols')
