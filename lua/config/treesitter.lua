local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
	-- A list of parser names, or "all" (the five listed parsers should always be installed)
	ensure_installed = {
		"c",
		"lua",
		"luadoc",
		"vim",
		"vimdoc",
		"query",
		"rust",
		"svelte",
		"typescript",
		"javascript",
		"json",
		"css",
		"html",
		"markdown",
		"markdown_inline",
	},

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- Automatically install missing parsers when entering buffer
	-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
	auto_install = true,

	highlight = {
		enable = true,
	},
})
