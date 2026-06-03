local M = {}

local state_file = vim.fn.stdpath("state") .. "/neocodeium-enabled"

local function options()
	local options_module = package.loaded["neocodeium.options"]
	return options_module and options_module.options or nil
end

local function load_neocodeium()
	if vim.fn.exists(":NeoCodeium") == 2 then
		return true
	end

	pcall(function()
		require("lazy").load({ plugins = { "neocodeium" } })
	end)

	return vim.fn.exists(":NeoCodeium") == 2
end

local function write_enabled(enabled)
	local ok, err = pcall(function()
		vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
		vim.fn.writefile({ enabled and "1" or "0" }, state_file)
	end)

	if not ok then
		vim.notify("Could not save NeoCodeium state: " .. err, vim.log.levels.WARN)
	end
end

function M.saved_enabled()
	local ok, lines = pcall(vim.fn.readfile, state_file)
	if not ok or not lines[1] then
		return true
	end

	return lines[1] ~= "0"
end

function M.is_enabled()
	local neocodeium_options = options()
	if neocodeium_options and neocodeium_options.enabled ~= nil then
		return neocodeium_options.enabled
	end

	return M.saved_enabled()
end

function M.persist_current_state()
	write_enabled(M.is_enabled())
end

function M.enable_persistence()
	vim.api.nvim_create_autocmd("User", {
		group = vim.api.nvim_create_augroup("neocodeium_persist_state", { clear = true }),
		pattern = {
			"NeoCodeiumEnabled",
			"NeoCodeiumDisabled",
		},
		callback = M.persist_current_state,
	})
end

function M.label()
	return "Clanker: " .. (M.is_enabled() and "ON" or "OFF")
end

function M.color()
	if M.is_enabled() then
		return { fg = "#98c379", gui = "bold" }
	end

	return { fg = "#e06c75", gui = "bold" }
end

function M.refresh_lualine()
	vim.schedule(function()
		local ok, lualine = pcall(require, "lualine")
		if ok then
			lualine.refresh()
		else
			vim.cmd.redrawstatus()
		end
	end)
end

function M.toggle()
	if not load_neocodeium() then
		vim.notify("NeoCodeium is not available", vim.log.levels.WARN)
		return
	end

	if M.is_enabled() then
		vim.cmd("NeoCodeium disable")
	else
		vim.cmd("NeoCodeium enable")
	end

	M.refresh_lualine()
end

return M
