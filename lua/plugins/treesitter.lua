return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    indent = false,
    incremental_selection = {
      enable = true,
      keymaps = {
        node_incremental = "v",
        node_decremental = "V",
      },
    },
  },
	--  config = function(_, opts)
	--      require("nvim-treesitter.configs").setup(opts)
	--      -- you can add your code here
	--      local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
	-- parser_config.xml_gen = {
	-- 	install_info = {
	-- 		url = "~/workspace/fun/tree-sitter-xml-gen",
	-- 		files = {"src/parser.c"}
	-- 	},
	-- 	filetype = "xml", -- if filetype does not agrees with parser name
	-- }
	--    end,
}
