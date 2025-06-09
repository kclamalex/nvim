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

require("typescript-tools").setup({
	on_attach = custom_attach,
	settings = {
		-- spawn additional tsserver instance to calculate diagnostics on it
		separate_diagnostic_server = true,
		-- "change"|"insert_leave" determine when the client asks the server about diagnostic
		publish_diagnostic_on = "insert_leave",
		-- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
		-- "remove_unused_imports"|"organize_imports") -- or string "all"
		-- to include all supported code actions
		-- specify commands exposed as code_actions
		expose_as_code_action = {},
		-- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
		-- not exists then standard path resolution strategy is applied
		tsserver_path = nil,
		-- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
		-- (see 💅 `styled-components` support section)
		tsserver_plugins = {},
		-- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
		-- memory limit in megabytes or "auto"(basically no limit)
		tsserver_max_memory = "auto",
		-- described below
		tsserver_format_options = {},
		tsserver_file_preferences = {},
		-- locale of all tsserver messages, supported locales you can find here:
		-- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
		tsserver_locale = "en",
		-- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
		complete_function_calls = false,
		include_completions_with_insert_text = true,
		-- CodeLens
		-- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
		-- possible values: ("off"|"all"|"implementations_only"|"references_only")
		code_lens = "off",
		-- by default code lenses are displayed on all referencable values and for some of you it can
		-- be too much this option reduce count of them by removing member references from lenses
		disable_member_code_lens = true,
		-- JSXCloseTag
		-- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
		-- that maybe have a conflict if enable this feature. )
		jsx_close_tag = {
			enable = false,
			filetypes = { "javascriptreact", "typescriptreact" },
		},
	},
})
-- Mason settings
local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")
local lsp_installed = {
	"vimls",
	"pylsp",
	"pyright",
	"ruff",
	"rust_analyzer",
	"lua_ls",
	"gopls",
	"yamlls",
	"clangd",
}
-- We need to set up mason before setting up mason-lspconfig
mason.setup()
mason_lspconfig.setup({
	ensure_installed = lsp_installed,
})

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
else
	vim.notify("rust-analyzer not found!", vim.log.levels.WARN, { title = "Nvim-config" })
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
else
	vim.notify("lua-language-server not found!", vim.log.levels.WARN, { title = "Nvim-config" })
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
	if utils.executable("ruff") then
		local on_attach = function(client, bufnr)
			-- Disable hover in favour of Pyright
			if client.name == "ruff" then
				client.server_capabilities.hoverProvider = false
			end
		end
		lspconfig.ruff.setup({ on_attach = on_attach })
	else
		vim.notify("ruff not found", vim.log.levels.WARN, { title = "Nvim-config" })
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

if utils.executable("yaml-language-server") then
	lspconfig.yamlls.setup({
		capabilities = capabilities,
	})
else
	vim.notify("yamlls not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

if utils.executable("gopls") then
	lspconfig.gopls.setup({
		on_attach = custom_attach,
		capabilities = capabilities,
		settings = {
			gopls = {
				analyses = {
					fieldalignment = true,
					nilness = true,
					unusedparams = true,
					unusedwrite = true,
					useany = true,
				},
				staticcheck = true,
				gofumpt = true,
			},
		},
	})
else
	vim.notify("gopls not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

-- assembly lsp
if utils.executable("asm-lsp") then
	lspconfig.asm_lsp.setup({
		capabilities = capabilities,
	})
else
	vim.notify("asm-lsp not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

-- C lsp
if utils.executable("clangd") then
	lspconfig.clangd.setup({
		capabilities = capabilities,
	})
else
	vim.notify("clangd not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end

-- Not using mason to manage ruby lsps
if utils.executable("ruby-lsp") then
	local is_rubocop_available = utils.executable("rubocop")
	if is_rubocop_available then
		lspconfig.rubocop.setup({})
	end
	local is_sorbet_available = utils.executable("srb")
	if is_sorbet_available then
		lspconfig.sorbet.setup({})
	end

	local cmd = { "ruby-lsp" }
	if utils.executable("bundle") then
		cmd = { "bundle", "exec", "ruby-lsp" }
	end

	lspconfig.ruby_lsp.setup({
		capabilities = capabilities,
		on_attach = custom_attach,
		cmd = cmd,
		settings = {
			ruby_lsp = {
				formatting = true,
				folding = true,
				references = true,
				rename = true,
				symbols = true,
				diagnostics = true,
				completion = true,
			},
		},
	})
else
	vim.notify("ruby-lsp not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end
