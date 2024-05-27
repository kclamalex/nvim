local fn = vim.fn
local api = vim.api
local keymap = vim.keymap
local lsp = vim.lsp
local diagnostic = vim.diagnostic

local utils = require("utils")

local lspconfig = require("lspconfig")

local capabilities = require("cmp_nvim_lsp").default_capabilities()

if utils.executable("rust-analyzer") then
	lspconfig.rust_analyzer.setup({
		capabilities = capabilities,
		settings = {
			["rust-analyzer"] = {
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
	local venv_path = os.getenv("VIRTUAL_ENV")
	local py_path = nil
	-- decide which python executable to use for mypy
	if venv_path ~= nil then
		py_path = venv_path .. "/bin/python3"
	else
		py_path = vim.g.python3_host_prog
	end

	lspconfig.pylsp.setup({
		settings = {
			pylsp = {
				plugins = {
					-- formatter options
					black = { enabled = true },
					autopep8 = { enabled = false },
					yapf = { enabled = false },
					-- linter options
					pylint = { enabled = true, executable = "pylint" },
					ruff = { enabled = false },
					pyflakes = { enabled = false },
					pycodestyle = { enabled = false },
					-- type checker
					pylsp_mypy = {
						enabled = true,
						overrides = { "--python-executable", py_path, true },
						report_progress = true,
						live_mode = false,
					},
					-- auto-completion options
					jedi_completion = { fuzzy = true },
					-- import sorting
					isort = { enabled = true },
				},
			},
		},
		flags = {
			debounce_text_changes = 200,
		},
		capabilities = capabilities,
	})
else
	vim.notify("pylsp not found!", vim.log.levels.WARN, { title = "Nvim-config" })
end
