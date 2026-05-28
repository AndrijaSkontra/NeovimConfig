-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Makes sure that vim help file will take the whole screen
vim.api.nvim_create_autocmd("FileType", {
	pattern = "help",
	callback = function()
		vim.bo.readonly = true
		vim.cmd("only")
	end,
	group = vim.api.nvim_create_augroup("vimdoc_autocmd", { clear = true }),
})

-- to sort tailwind classes
-- vim.cmd("TailwindSort")

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.note",
	callback = function()
		vim.cmd("colorscheme kanagawa-lotus")
	end,
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, {
				buffer = event.buf,
				desc = "LSP: " .. desc,
			})
		end
		map("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
		map("gh", vim.lsp.buf.references, "[G]oto [R]eferences")
		map("gi", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
		map("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		-- map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		map("K", vim.lsp.buf.hover, "Hover Documentation")
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	end,
})
