local function getTypescriptFormater()
	return { "prettier" }
	-- return { "deno_fmt" }
end

return {
	"stevearc/conform.nvim",
	event = "BufWritePre",
	cmd = "ConformInfo",
	opts = {
		notify_on_error = true,
		format_on_save = function(bufnr)
			local ft = vim.bo[bufnr].filetype
			return {
				timeout_ms = ft == "ruby" and 10000 or 1000,
				-- sqls formatting is non-idempotent and flips style on each save
				lsp_format = ft == "sql" and "never" or "fallback",
			}
		end,
		formatters_by_ft = {
			go = { lsp_format = "first" },
			gomod = { lsp_format = "first" },
			gowork = { lsp_format = "first" },
			gotmpl = { lsp_format = "first" },
			java = { "astyle" },
			lua = { "stylua" },
			ruby = { "standardrb" },
			elixir = { "mix", stop_after_first = true },
			javascript = getTypescriptFormater(),
			javascriptreact = getTypescriptFormater(),
			html = getTypescriptFormater(),
			css = getTypescriptFormater(),
			typescriptreact = getTypescriptFormater(),
			typescript = getTypescriptFormater(),
			ts = getTypescriptFormater(),
			tsx = getTypescriptFormater(),
			handlebars = { "djlint" },
			php = { "pint", "php_cs_fixer", "phpcbf", stop_after_first = true },
			-- python = { "ruff" },
			-- c = { "clang-format" },
		},
	},
}
