local conform = require("conform")

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		rust = { "rustfmt", lsp_format = "fallback" },
		markdown = { "deno_fmt", lsp_format = "fallback" },
		ruby = { "rubocop" },
		typescript = { "prettier" },
		typescriptreact = { "prettier" },
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		json = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
	},
})

-- Customised formatters
conform.setup({
	formatters = {
		rubocop = {
			args = { "-a", "-f", "quiet", "--stderr", "--stdin", "$FILENAME" },
		},
	},
})
