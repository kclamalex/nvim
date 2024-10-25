local fn = vim.fn
local api = vim.api
local lsp = vim.lsp
local diagnostic = vim.diagnostic

local utils = require("utils")

local lspconfig = require("lspconfig")

local capabilities = require("cmp_nvim_lsp").default_capabilities()

local custom_attach = function(client, bufnr)
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
	end

	utils.keymap("n", "gd", vim.lsp.buf.definition, { desc = "go to definition" })
	utils.keymap("n", "K", vim.lsp.buf.hover)
	utils.keymap("n", "<C-k>", vim.lsp.buf.signature_help)
	utils.keymap("n", "<space>rn", vim.lsp.buf.rename, { desc = "varialbe rename" })
	utils.keymap("n", "gr", vim.lsp.buf.references, { desc = "show references" })
	utils.keymap("n", "[d", diagnostic.goto_prev, { desc = "previous diagnostic" })
	utils.keymap("n", "]d", diagnostic.goto_next, { desc = "next diagnostic" })
	api.nvim_create_autocmd("CursorHold", {
		buffer = bufnr,
		callback = function()
			local float_opts = {
				focusable = false,
				close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
				border = "rounded",
				source = "always", -- show source in diagnostic popup window
				prefix = " ",
			}

			if not vim.b.diagnostics_pos then
				vim.b.diagnostics_pos = { nil, nil }
			end

			local cursor_pos = api.nvim_win_get_cursor(0)
			if
				(cursor_pos[1] ~= vim.b.diagnostics_pos[1] or cursor_pos[2] ~= vim.b.diagnostics_pos[2])
				and #diagnostic.get() > 0
			then
				diagnostic.open_float(nil, float_opts)
			end

			vim.b.diagnostics_pos = cursor_pos
		end,
	})

	-- The blow command will highlight the current variable and its usages in the buffer.
	if client.server_capabilities.documentHighlightProvider then
		vim.cmd([[
      hi! link LspReferenceRead Visual
      hi! link LspReferenceText Visual
      hi! link LspReferenceWrite Visual
    ]])

		local gid = api.nvim_create_augroup("lsp_document_highlight", { clear = true })
		api.nvim_create_autocmd("CursorHold", {
			group = gid,
			buffer = bufnr,
			callback = function()
				lsp.buf.document_highlight()
			end,
		})

		api.nvim_create_autocmd("CursorMoved", {
			group = gid,
			buffer = bufnr,
			callback = function()
				lsp.buf.clear_references()
			end,
		})
	end

	if vim.g.logging_level == "debug" then
		local msg = string.format("Language server %s started!", client.name)
		vim.notify(msg, vim.log.levels.DEBUG, { title = "Nvim-config" })
	end
end

if utils.executable("rust-analyzer") then
	lspconfig.rust_analyzer.setup({
		capabilities = capabilities,
		on_attach = custom_attach,
		cmd = { "rustup", "run", "stable", "rust-analyzer" },
		settings = {
			["rust-analyzer"] = {
				imports = {
					granularity = {
						group = "module",
					},
					prefix = "self",
				},
				cargo = {
					buildScripts = {
						enable = true,
					},
				},
				procMacro = {
					enable = true,
				},
				diagnostics = {
					enable = true,
				},
			},
		},
	})
end

if utils.executable("lua-language-server") then
	-- settings for lua-language-server can be found on https://github.com/LuaLS/lua-language-server/wiki/Settings .
	lspconfig.lua_ls.setup({

		on_attach = custom_attach,
		settings = {
			Lua = {
				runtime = {
					-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
					version = "LuaJIT",
				},
				diagnostics = {
					-- Get the language server to recognize the `vim` global
					globals = { "vim" },
				},
				workspace = {
					-- Make the server aware of Neovim runtime files,
					-- see also https://github.com/LuaLS/lua-language-server/wiki/Libraries#link-to-workspace .
					-- Lua-dev.nvim also has similar settings for lua ls, https://github.com/folke/neodev.nvim/blob/main/lua/neodev/luals.lua .
					library = {
						vim.env.VIMRUNTIME,
						fn.stdpath("config"),
					},
					maxPreload = 2000,
					preloadFileSize = 50000,
				},
			},
		},
		capabilities = capabilities,
	})
end

if utils.executable("pylsp") then
	lspconfig.pylsp.setup({
		on_attach = custom_attach,
		settings = {
			pylsp = {
				plugins = {
					-- formatter options
					black = { enabled = true },
					autopep8 = { enabled = false },
					yapf = { enabled = false },
				},
			},
		},
		flags = {
			debounce_text_changes = 200,
		},
		capabilities = capabilities,
	})
	-- Setting ruff and pyright separately
	if utils.executable("ruff-lsp") then
		local on_attach = function(client, bufnr)
			-- Disable hover in favour of Pyright
			if client.name == "ruff_lsp" then
				client.server_capabilities.hoverProvider = false
			end
		end
		lspconfig.ruff_lsp.setup({ on_attach = on_attach })
	else
		vim.notify("ruff-lsp not found", vim.log.levels.WARN, { title = "Nvim-config" })
	end
	if utils.executable("pyright") then
		lspconfig.pyright.setup({
			settings = {
				pyright = {
					-- Using Ruff's import organizer
					disableOrganizeImports = true,
				},
				python = {
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "openFilesOnly",
						typeCheckingMode = "off",
					},
				},
			},
		})
	else
		vim.notify("pyright not found", vim.log.levels.WARN, { title = "Nvim-config" })
	end
else
	vim.notify("pylsp not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

if utils.executable("vim-language-server") then
	lspconfig.vimls.setup({
		diagnostic = {
			enable = true,
		},
		indexes = {
			count = 3,
			gap = 100,
			projectRootPatterns = { "runtime", "nvim", ".git", "autoload", "plugin" },
			runtimepath = true,
		},
		isNeovim = true,
		iskeyword = "@,48-57,_,192-255,-#",
		runtimepath = "",
		suggest = {
			fromRuntimepath = true,
			fromVimruntime = true,
		},
		vimruntime = "",
		capabilities = capabilities,
	})
else
	vim.notify("vimls not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

if utils.executable("typescript-language-server") then
	lspconfig.tsserver.setup({
		capabilities = capabilities,
	})
else
	vim.notify("tsserver not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

if utils.executable("svelteserver") then
	lspconfig.svelte.setup({
		capabilities = capabilities,
	})
else
	vim.notify("svelte not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end


if utils.executable("yaml-language-server") then
	lspconfig.yamlls.setup({
		capabilities = capabilities,
	})
else
	vim.notify("yamlls not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

if utils.executable("gopls") then
	lspconfig.gopls.setup({
		capabilities = capabilities,
	})
else
	vim.notify("gopls not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end
