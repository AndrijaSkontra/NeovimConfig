local M = {}

local state_file = vim.fn.stdpath("state") .. "/omarchy-theme-sync"

local themes = {
	["catppuccin"] = { label = "Catppuccin", colorscheme = "catppuccin-mocha", background = "dark" },
	["catppuccin-latte"] = { label = "Catppuccin Latte", colorscheme = "catppuccin-latte", background = "light" },
	["ethereal"] = { label = "Ethereal", colorscheme = "tokyonight-moon", background = "dark" },
	["everforest"] = { label = "Everforest", colorscheme = "everforest", background = "dark" },
	["flexoki-light"] = { label = "Flexoki Light", colorscheme = "flexoki-light", background = "light" },
	["gruvbox"] = { label = "Gruvbox", colorscheme = "gruvbox", background = "dark" },
	["hackerman"] = { label = "Hackerman", colorscheme = "hackerman", background = "dark" },
	["kanagawa"] = { label = "Kanagawa", colorscheme = "kanagawa", background = "dark" },
	["last-horizon"] = { label = "Last Horizon", colorscheme = "rose-pine-main", background = "dark" },
	["lumon"] = { label = "Lumon", colorscheme = "lumon", background = "dark" },
	["lupine"] = { label = "Lupine", colorscheme = "rose-pine-dawn", background = "light" },
	["matte-black"] = { label = "Matte Black", colorscheme = "matteblack", background = "dark" },
	["miasma"] = { label = "Miasma", colorscheme = "melange", background = "dark" },
	["nord"] = { label = "Nord", colorscheme = "nordfox", background = "dark" },
	["osaka-jade"] = { label = "Osaka Jade", colorscheme = "bamboo", background = "dark" },
	["retro-82"] = { label = "Retro 82", colorscheme = "retro-82", background = "dark" },
	["ristretto"] = { label = "Ristretto", colorscheme = "catppuccin-macchiato", background = "dark" },
	["rose-pine"] = { label = "Rose Pine", colorscheme = "rose-pine-dawn", background = "light" },
	["solitude"] = { label = "Solitude", colorscheme = "ashen", background = "dark" },
	["tokyo-night"] = { label = "Tokyo Night", colorscheme = "tokyonight-night", background = "dark" },
	["vantablack"] = { label = "Vantablack", colorscheme = "matteblack", background = "dark" },
	["white"] = { label = "White", colorscheme = "github_light", background = "light" },
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

function M.apply_omarchy_slug(slug)
	local spec = themes[slug]
	if not spec then
		return false
	end

	vim.opt.background = spec.background

	local ok = pcall(vim.cmd.colorscheme, spec.colorscheme)
	if not ok then
		vim.notify("Failed to apply colorscheme: " .. spec.colorscheme, vim.log.levels.WARN)
		return false
	end

	write_state(slug)
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
			colorscheme = spec.colorscheme,
			before = ([[vim.opt.background = %q
if %q == "everforest" then
	vim.g.everforest_background = "soft"
end]]):format(spec.background, slug),
		}
	end
	return entries
end

function M.setup_autosync()
	local group = vim.api.nvim_create_augroup("omarchy-theme-sync", { clear = true })
	local last_state = nil

	vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained", "CursorHold" }, {
		group = group,
		callback = function(args)
			local state = read_state()
			if args.event == "VimEnter" then
				if state and state ~= "" then
					local slug = resolve_slug(state)
					if slug then
						M.apply_omarchy_slug(slug)
						last_state = slug
						return
					end
				end

				if M.apply_current_omarchy_theme() then
					last_state = read_state()
				end
				return
			end

			if state and state ~= "" and state ~= last_state then
				local slug = resolve_slug(state)
				if slug then
					M.apply_omarchy_slug(slug)
					last_state = slug
				end
			end
		end,
	})
end

return M
