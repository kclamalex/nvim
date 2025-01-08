vim.loader.enable()

local version = vim.version

-- check if we have the latest stable version of nvim
local expected_ver = "0.10.3"
local ev = version.parse(expected_ver)
local actual_ver = version()

local result = version.cmp(ev, { actual_ver.major, actual_ver.minor, actual_ver.patch })

if result ~= 0 then
	local _ver = string.format("%s.%s.%s", actual_ver.major, actual_ver.minor, actual_ver.patch)
	local msg = string.format("Expect nvim %s, but got %s instead. Use at your own risk!", expected_ver, _ver)
	vim.api.nvim_err_writeln(msg)
end

local core_conf_files = {
	"globals.vim", -- global settings
	"commands.lua", -- custom commands
	"keymap.lua", -- Keymap configurations
	"plugins.vim", -- all the plugins installed and their configurations
}

local vim_conf_dir = vim.fn.stdpath("config") .. "/vim_conf"
-- source all the core config files
for _, file_name in ipairs(core_conf_files) do
	if vim.endswith(file_name, "vim") then
		local path = string.format("%s/%s", vim_conf_dir, file_name)
		local source_cmd = "source " .. path
		vim.cmd(source_cmd)
	else
		local module_name, _ = string.gsub(file_name, "%.lua", "")
		package.loaded[module_name] = nil
		require(module_name)
	end
end
