local neotest = require("neotest")
local neotest_python = require("neotest-python")
local utils = require("utils")
-- TODO: Build a function to find python executable for that virtual env
local opts = { noremap = true, silent = true }
neotest.setup({
	adapters = {
		neotest_python,
	},
})

-- Run test file
utils.keymap("n", "<leader>tt", function()
	neotest.run.run(vim.fn.expand("%"))
end, opts)
-- Run all files
utils.keymap("n", "<leader>tt", function()
	neotest.run.run(vim.uv.cwd())
end, opts)
-- Run nearest
utils.keymap("n", "<leader>tn", function()
	neotest.run.run()
end, opts)
-- Run last
utils.keymap("n", "<leader>tl", function()
	neotest.run.run_last()
end, opts)
-- Toggle Summary
utils.keymap("n", "<leader>ts", function()
	neotest.summary.toggle()
end, opts)
-- Stop test
utils.keymap("n", "<leader>tk", function()
	neotest.run.stop()
end, opts)
-- Toggle output panel
utils.keymap("n", "<leader>to", function()
	neotest.output_panel.toggle()
end, opts)

