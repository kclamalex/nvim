local cmp = require("cmp")
cmp.setup({
	sources = {
		{ name = "nvim_lsp" },
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		["<A-b>"] = cmp.mapping.scroll_docs(-4),
		["<A-f>"] = cmp.mapping.scroll_docs(4),
		["<A-Space>"] = cmp.mapping.complete(),
		["<A-e>"] = cmp.mapping.abort(),
		["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
	}),
})
