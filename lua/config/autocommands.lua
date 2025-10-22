-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Don't show lazy window on nvim enter (of updates)
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		require("lazy").update({
			show = false,
		})
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
--
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = "*.note",
	callback = function()
		vim.cmd("colorscheme kanagawa-lotus")
	end,
})

-- copilot lsp attach
-- vim.api.nvim_create_autocmd("LspAttach", {
-- 	callback = function(args)
-- 		local bufnr = args.buf
-- 		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
--
-- 		if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, bufnr) then
-- 			vim.lsp.inline_completion.enable(true, { bufnr = bufnr })
--
-- 			vim.keymap.set(
-- 				"i",
-- 				"<C-F>",
-- 				vim.lsp.inline_completion.get,
-- 				{ desc = "LSP: accept inline completion", buffer = bufnr }
-- 			)
-- 			vim.keymap.set(
-- 				"i",
-- 				"<C-G>",
-- 				vim.lsp.inline_completion.select,
-- 				{ desc = "LSP: switch inline completion", buffer = bufnr }
-- 			)
-- 		end
-- 	end,
-- })
