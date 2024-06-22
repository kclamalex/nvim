local fn = vim.fn

local M = {}

-- Key mapping with lua api
function M.keymap(mode, lhs, rhs, opts)
	local options = { noremap = true, silent = true }
	if opts then
		options = vim.tbl_extend("force", options, opts)
	end
	vim.keymap.set(mode, lhs, rhs, options)
end

-- Check if the executable exists
function M.executable(name)
	if fn.executable(name) > 0 then
		return true
	end

	return false
end

-- Load custom config file for specific module
function M.load_custom_config(module_name)
	local custom_module_name = "custom_" .. module_name
	local plugin_config_dir = vim.fn.stdpath("config") .. "/lua/config/"
	local module_to_load = "config." .. module_name
	if vim.fn.filereadable(plugin_config_dir .. custom_module_name) then
		module_to_load = "config." .. custom_module_name
	end
	local config = function()
		require(module_to_load)
	end
	return config
end

return M
