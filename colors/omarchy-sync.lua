local sync = require("config.helpers.omarchy-theme-sync")

local slug = sync.get_active_theme() or "tokyo-night"
local palette = sync.theme_palette(slug)
if not palette then
	palette = sync.theme_palette("tokyo-night")
end
if not palette then
	return
end

local dark = palette.mode ~= "light"
vim.opt.background = dark and "dark" or "light"

vim.cmd("hi clear")
if vim.fn.exists("syntax_on") == 1 then
	vim.cmd("syntax reset")
end
vim.g.colors_name = "omarchy-sync"

local p = palette
local set = vim.api.nvim_set_hl

set(0, "Normal", { fg = p.foreground, bg = p.background })
set(0, "NormalFloat", { fg = p.foreground, bg = p.dark_background })
set(0, "FloatBorder", { fg = p.muted, bg = p.dark_background })
set(0, "CursorLine", { bg = p.lighter_background })
set(0, "CursorColumn", { bg = p.lighter_background })
set(0, "LineNr", { fg = p.dark_foreground, bg = p.background })
set(0, "CursorLineNr", { fg = p.accent, bold = true, bg = p.background })
set(0, "SignColumn", { fg = p.dark_foreground, bg = p.background })
set(0, "ColorColumn", { bg = p.dark_background })
set(0, "Visual", { bg = p.selection })
set(0, "Search", { fg = p.background, bg = p.accent, bold = true })
set(0, "IncSearch", { fg = p.background, bg = p.orange or p.yellow, bold = true })
set(0, "Pmenu", { fg = p.foreground, bg = p.dark_background })
set(0, "PmenuSel", { fg = p.bright_foreground, bg = p.selection, bold = true })
set(0, "StatusLine", { fg = p.light_foreground, bg = p.dark_background })
set(0, "StatusLineNC", { fg = p.dark_foreground, bg = p.dark_background })
set(0, "VertSplit", { fg = p.dark_foreground, bg = p.background })
set(0, "WinSeparator", { fg = p.dark_foreground, bg = p.background })
set(0, "TabLine", { fg = p.dark_foreground, bg = p.dark_background })
set(0, "TabLineSel", { fg = p.bright_foreground, bg = p.selection, bold = true })
set(0, "Directory", { fg = p.blue })
set(0, "Identifier", { fg = p.cyan })
set(0, "Function", { fg = p.blue })
set(0, "Statement", { fg = p.magenta })
set(0, "Keyword", { fg = p.magenta, italic = true })
set(0, "Type", { fg = p.yellow })
set(0, "String", { fg = p.green })
set(0, "Comment", { fg = p.dark_foreground, italic = true })
set(0, "Constant", { fg = p.orange or p.yellow })
set(0, "Special", { fg = p.accent })
set(0, "Error", { fg = p.red, bold = true })
set(0, "WarningMsg", { fg = p.yellow, bold = true })
set(0, "MoreMsg", { fg = p.green })
set(0, "ModeMsg", { fg = p.cyan })
set(0, "DiagnosticError", { fg = p.red })
set(0, "DiagnosticWarn", { fg = p.yellow })
set(0, "DiagnosticInfo", { fg = p.blue })
set(0, "DiagnosticHint", { fg = p.cyan })
set(0, "DiagnosticOk", { fg = p.green })
set(0, "DiffAdd", { bg = p.green, fg = p.background })
set(0, "DiffDelete", { bg = p.red, fg = p.background })
set(0, "DiffChange", { bg = p.blue, fg = p.background })
set(0, "DiffText", { bg = p.accent, fg = p.background, bold = true })
