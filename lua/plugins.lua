local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local utils = require("utils")
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

local plugin_specs = {
	-- typescript tools
	{
		"pmizio/typescript-tools.nvim",
		dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
		opts = {},
	},
	-- nvim web devicons
	{ "nvim-tree/nvim-web-devicons", opts = {} },
	-- trouble
	{
		"folke/trouble.nvim",
		opts = {}, -- for default options, refer to the configuration section for custom setup.
		cmd = "Trouble",
		keys = {
			{
				"<leader>xx",
				"<cmd>Trouble diagnostics toggle<cr>",
				desc = "Diagnostics (Trouble)",
			},
			{
				"<leader>xX",
				"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
				desc = "Buffer Diagnostics (Trouble)",
			},
			{
				"<leader>cs",
				"<cmd>Trouble symbols toggle focus=false<cr>",
				desc = "Symbols (Trouble)",
			},
			{
				"<leader>cl",
				"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
				desc = "LSP Definitions / references / ... (Trouble)",
			},
			{
				"<leader>xL",
				"<cmd>Trouble loclist toggle<cr>",
				desc = "Location List (Trouble)",
			},
			{
				"<leader>xQ",
				"<cmd>Trouble qflist toggle<cr>",
				desc = "Quickfix List (Trouble)",
			},
		},
	},
	-- ============================ LSP settings ===================================
	-- Language server
	{
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hints = { enabled = true },
		},
		dependencies = {
			{ "williamboman/mason.nvim", tag = "v1.11.0" },
			{
				"williamboman/mason-lspconfig.nvim",
				tag = "v1.32.0",
			},
		},
		config = function()
			require("config.lsp")
		end,
	},
	-- ============================ LSP settings ===================================
	-- leap.nvim
	{
		"ggandor/leap.nvim",
		config = function()
			require("leap").create_default_mappings()
		end,
	},
	-- autopairs
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		-- use opts = {} for passing setup options
		-- this is equalent to setup({}) function
	},
	-- Ident lines
	{ "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },
	-- Github integration
	{
		"pwntester/octo.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("octo").setup({})
		end,
	},
	-- Formattor
	{
		"stevearc/conform.nvim",
		config = function()
			require("config.nvim-conform")
		end,
	},
	-- Surround plugin
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({
				-- Configuration here, or leave empty to use defaults
			})
		end,
	},
	-- project management
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("config.projects")
		end,
	},
	-- diff view plugin for git
	{
		"sindrets/diffview.nvim",
		config = function()
			require("config.diffview")
		end,
	},
	-- Hybrid line number plugin
	{
		"myusuf3/numbers.vim",
	},
	-- Comment plugin
	{
		"numToStr/Comment.nvim",
		lazy = false,
		config = function()
			require("config.comment")
		end,
	},
	-- Git highlights
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("config.gitsigns")
		end,
	},
	-- Syntax highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("config.treesitter")
		end,
	},
	-- Auto completion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("config.cmp")
		end,
	},
	-- better UI for vim.ui
	{
		"stevearc/dressing.nvim",
		opts = {},
	},
	-- Fzf plugin for telescope
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_POLICY_VERSION_MINIMUM=3.5 -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
	},
	-- Fuzzy finder for searching files
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("config.telescope")
		end,
	},
	-- Better escape from insert mode
	{ "nvim-zh/better-escape.vim" },
	-- status line
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("config.lualine")
		end,
	},
	-- file explorer
	{
		"nvim-tree/nvim-tree.lua",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("config.nvim-tree")
		end,
	},
	-- Git command inside vim
	{
		"tpope/vim-fugitive",
		config = function()
			require("config.fugitive")
		end,
	},
	-- fancy start screen
	{
		"nvimdev/dashboard-nvim",
		config = utils.load_custom_config("dashboard-nvim"),
	},
	{
		"sainnhe/gruvbox-material",
		lazy = false,
		priority = 1000,
		config = function()
			-- Optionally configure and load the colorscheme
			-- directly inside the plugin declaration.
			vim.g.gruvbox_material_enable_italic = true
			vim.cmd.colorscheme("gruvbox-material")
		end,
	},
}
-- obsidian
if utils.executable("/Users/klam/Documents/obsidian") then
	local obsidian_opts = {
		"epwalsh/obsidian.nvim",
		tag = "v3.9.0", -- recommended, use latest release instead of latest commit
		requires = {
			-- Required.
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
			"nvim-telescope/telescope.nvim",
			"nvim-treesitter",
			-- see below for full list of optional dependencies 👇
		},
		config = function()
			require("config.obsidian")
		end,
	}
	table.insert(plugin_specs, obsidian_opts)
end

-- windsurf
if utils.executable("windsurf") then
	local windsurf_opts = {
		"Exafunction/windsurf.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"hrsh7th/nvim-cmp",
		},
		config = function()
			require("codeium").setup({})
		end,
	}
	table.insert(plugin_specs, windsurf_opts)
end

local lazy_opts = {
	ui = {
		border = "rounded",
		title = "Plugin Manager",
		title_pos = "center",
	},
}

require("lazy").setup(plugin_specs, lazy_opts)
