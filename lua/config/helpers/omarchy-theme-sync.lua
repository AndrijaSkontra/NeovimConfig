local M = {}

local state_file = vim.fn.stdpath("state") .. "/omarchy-theme-sync"
local system_themes_dir = "/usr/share/omarchy/themes"
local user_themes_dir = vim.fn.expand("~/.config/omarchy/themes")
local active_slug = nil

local themes = {
	["catppuccin"] = { label = "Catppuccin" },
	["catppuccin-latte"] = { label = "Catppuccin Latte" },
	["ethereal"] = { label = "Ethereal" },
	["everforest"] = { label = "Everforest" },
	["flexoki-light"] = { label = "Flexoki Light" },
	["gruvbox"] = { label = "Gruvbox" },
	["hackerman"] = { label = "Hackerman" },
	["kanagawa"] = { label = "Kanagawa" },
	["last-horizon"] = { label = "Last Horizon" },
	["lumon"] = { label = "Lumon" },
	["lupine"] = { label = "Lupine" },
	["matte-black"] = { label = "Matte Black" },
	["miasma"] = { label = "Miasma" },
	["nord"] = { label = "Nord" },
	["osaka-jade"] = { label = "Osaka Jade" },
	["retro-82"] = { label = "Retro 82" },
	["ristretto"] = { label = "Ristretto" },
	["rose-pine"] = { label = "Rose Pine" },
	["solitude"] = { label = "Solitude" },
	["tokyo-night"] = { label = "Tokyo Night" },
	["vantablack"] = { label = "Vantablack" },
	["white"] = { label = "White" },
}

local ordered_slugs = {
	"catppuccin",
	"catppuccin-latte",
	"ethereal",
	"everforest",
	"flexoki-light",
	"gruvbox",
	"hackerman",
	"kanagawa",
	"last-horizon",
	"lumon",
	"lupine",
	"matte-black",
	"miasma",
	"nord",
	"osaka-jade",
	"retro-82",
	"ristretto",
	"rose-pine",
	"solitude",
	"tokyo-night",
	"vantablack",
	"white",
}

local function normalize(value)
	return value:lower():gsub("[^%w]+", "-"):gsub("^%-+", ""):gsub("%-+$", "")
end

local function write_state(slug)
	vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
	vim.fn.writefile({ slug }, state_file)
end

local function read_state()
	if vim.fn.filereadable(state_file) == 0 then
		return nil
	end

	local lines = vim.fn.readfile(state_file)
	return lines[1]
end

local function sync_lualine()
	vim.schedule(function()
		local ok, lualine = pcall(require, "lualine")
		if ok then
			lualine.setup()
		end
	end)
end

local function resolve_slug(value)
	if not value or value == "" then
		return nil
	end

	local normalized = normalize(value)
	if themes[normalized] then
		return normalized
	end

	for slug, spec in pairs(themes) do
		if normalize(spec.label) == normalized then
			return slug
		end
	end

	return nil
end

local function parse_toml_palette(path)
	local palette = {}
	for _, line in ipairs(vim.fn.readfile(path)) do
		local key, value = line:match('^%s*([%w_]+)%s*=%s*"(.-)"%s*$')
		if key and value then
			palette[key] = value
		end
	end
	return palette
end

local function theme_palette_path(slug)
	local user_path = user_themes_dir .. "/" .. slug .. "/colors.toml"
	if vim.fn.filereadable(user_path) == 1 then
		return user_path
	end

	local system_path = system_themes_dir .. "/" .. slug .. "/colors.toml"
	if vim.fn.filereadable(system_path) == 1 then
		return system_path
	end

	return nil
end

function M.theme_palette(slug)
	local path = theme_palette_path(slug)
	if not path then
		return nil
	end

	local palette = parse_toml_palette(path)
	if not palette.mode then
		palette.mode = "dark"
	end
	palette.slug = slug
	return palette
end

function M.set_active_theme(slug)
	if themes[slug] then
		active_slug = slug
	end
end

function M.get_active_theme()
	return active_slug
end

function M.apply_omarchy_slug(slug)
	if not themes[slug] then
		return false
	end

	active_slug = slug
	local ok = pcall(vim.cmd.colorscheme, "omarchy-sync")
	if not ok then
		vim.notify("Failed to apply colorscheme for Omarchy theme: " .. slug, vim.log.levels.WARN)
		return false
	end

	write_state(slug)
	sync_lualine()
	return true
end

function M.apply_current_omarchy_theme()
	if vim.fn.executable("omarchy") ~= 1 then
		return false
	end

	local lines = vim.fn.systemlist({ "omarchy", "theme", "current" })
	if vim.v.shell_error ~= 0 or #lines == 0 then
		return false
	end

	local slug = resolve_slug(lines[1])
	if not slug then
		return false
	end

	return M.apply_omarchy_slug(slug)
end

function M.themery_entries()
	local entries = {}
	for _, slug in ipairs(ordered_slugs) do
		local spec = themes[slug]
		entries[#entries + 1] = {
			name = "Omarchy: " .. spec.label,
			colorscheme = "omarchy-sync",
			before = ([[require("config.helpers.omarchy-theme-sync").set_active_theme(%q)]]):format(slug),
		}
	end
	return entries
end

local function fetch_omarchy_slug()
	if vim.fn.executable("omarchy") ~= 1 then
		return nil
	end

	local lines = vim.fn.systemlist({ "omarchy", "theme", "current" })
	if vim.v.shell_error ~= 0 or #lines == 0 then
		return nil
	end

	return resolve_slug(lines[1])
end

function M.setup_autosync()
	local group = vim.api.nvim_create_augroup("omarchy-theme-sync", { clear = true })
	local last_slug = nil

	local function apply_slug(slug)
		if not slug or slug == last_slug then
			return
		end

		if M.apply_omarchy_slug(slug) then
			last_slug = slug
		end
	end

	vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained", "CursorHold" }, {
		group = group,
		callback = function(args)
			if args.event == "VimEnter" or args.event == "FocusGained" then
				local slug = fetch_omarchy_slug()
				if not slug and args.event == "VimEnter" then
					slug = resolve_slug(read_state())
				end
				apply_slug(slug)
				return
			end

			local slug = resolve_slug(read_state())
			apply_slug(slug)
		end,
	})
end

return M
