local neotest = require("neotest")
local keymap = vim.keymap
local neotest_python = require("neotest-python")
-- TODO: Build a function to find python executable for that virtual env
local opts = { noremap = true, silent = true }
neotest.setup({
	adapters = {
		neotest_python,
	},
})

-- Run test file
keymap.set("n", "<leader>tt", function()
	neotest.run.run(vim.fn.expand("%"))
end, opts)
-- Run all files
keymap.set("n", "<leader>tt", function()
	neotest.run.run(vim.uv.cwd())
end, opts)
-- Run nearest
keymap.set("n", "<leader>tn", function()
	neotest.run.run()
end, opts)
-- Run last
keymap.set("n", "<leader>tl", function()
	neotest.run.run_last()
end, opts)
-- Toggle Summary
keymap.set("n", "<leader>ts", function()
	neotest.summary.toggle()
end, opts)
-- Stop test
keymap.set("n", "<leader>tk", function()
	neotest.run.stop()
end, opts)
-- Toggle output panel
keymap.set("n", "<leader>to", function()
	neotest.output_panel.toggle()
end, opts)

