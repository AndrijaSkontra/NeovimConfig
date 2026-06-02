local M = {}

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

function M.is_enabled()
	local neocodeium_options = options()
	if neocodeium_options and neocodeium_options.enabled ~= nil then
		return neocodeium_options.enabled
	end

	return true
end

function M.label()
	return "AI assist: " .. (M.is_enabled() and "ON" or "OFF")
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
