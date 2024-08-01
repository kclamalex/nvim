local api = vim.api
local utils = require("utils")
local dashboard = require("dashboard")

local conf = {}
conf.header = {
	"                                                      ",
	"                                                      ",
	"███╗   ██╗ ███████╗ ██████╗  ██╗   ██╗ ██╗ ███╗   ███╗",
	"████╗  ██║ ██╔════╝██╔═══██╗ ██║   ██║ ██║ ████╗ ████║",
	"██╔██╗ ██║ █████╗  ██║   ██║ ██║   ██║ ██║ ██╔████╔██║",
	"██║╚██╗██║ ██╔══╝  ██║   ██║ ╚██╗ ██╔╝ ██║ ██║╚██╔╝██║",
	"██║ ╚████║ ███████╗╚██████╔╝  ╚████╔╝  ██║ ██║ ╚═╝ ██║",
	"╚═╝  ╚═══╝ ╚══════╝ ╚═════╝    ╚═══╝   ╚═╝ ╚═╝     ╚═╝",
	"                                                      ",
	"                                                      ",
}

conf.center = {
	{
		icon = "󰈞  ",
		desc = "Find  File                              ",
		action = "Telescope find_files",
		key = "<Leader> f f",
	},
	{
		icon = "󰈢  ",
		desc = "Recently opened files                   ",
		action = "Telescope oldfiles",
		key = "<Leader> f r",
	},
	{
		icon = "󰈬  ",
		desc = "Project grep                            ",
		action = "Telescope live_grep",
		key = "<Leader> f g",
	},
	{
		icon = "  ",
		desc = "New file                                ",
		action = "enew",
		key = "e",
	},
	{
		icon = "󰗼  ",
		desc = "Quit Nvim                               ",
		-- desc = "Quit Nvim                               ",
		action = "qa",
		key = "q",
	},
}

dashboard.setup({
	theme = "doom",
	shortcut_type = "number",
	config = conf,
})

api.nvim_create_autocmd("FileType", {
	pattern = "dashboard",
	group = api.nvim_create_augroup("dashboard_enter", { clear = true }),
	callback = function()
		utils.keymap("n", "q", ":qa<CR>", { buffer = true, silent = true })
		utils.keymap("n", "e", ":enew<CR>", { buffer = true, silent = true })
	end,
})
