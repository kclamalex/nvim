local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

-- check if firenvim is active
local firenvim_not_active = function()
	return not vim.g.started_by_firenvim
end

local plugin_specs = {
	-- Copilot plugin
	{
		"github/copilot.vim",
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
	-- Fuzzy finder for searching files
	{ "Yggdroot/LeaderF" },
	-- Tool to run tests
	{
		"nvim-neotest/neotest",
		config = function()
			require('config.neotest')
		end,
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-python",
		},
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
		keys = { "<leader>t" },
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			config = function()
				require("config.nvim-tree")
			end,
		},
	},
	-- Git command inside vim
	{
		"tpope/vim-fugitive",
		config = function()
			require("config.fugitive")
		end,
	},
	-- Language server
	{
		"neovim/nvim-lspconfig",
		opts = {
			inlay_hints = { enabled = true },
		},
		config = function()
			require("config.lsp")
		end,
	},
	-- Edit text area in browser using nvim
	{
		"glacambre/firenvim",
		enabled = function()
			if vim.g.is_win or vim.g.is_mac then
				return true
			end
			return false
		end,
		build = function()
			vim.fn["firenvim#install"](0)
		end,
		lazy = true,
	},
	-- Auto format tools
	{ "sbdchd/neoformat", cmd = { "Neoformat" } },
	-- fancy start screen
	{
		"nvimdev/dashboard-nvim",
		cond = firenvim_not_active,
		config = function()
			require("config.dashboard-nvim")
		end,
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

local lazy_opts = {
	ui = {
		border = "rounded",
		title = "Plugin Manager",
		title_pos = "center",
	},
}

require("lazy").setup(plugin_specs, lazy_opts)
