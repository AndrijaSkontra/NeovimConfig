vim.lsp.config("denols", {
	root_markers = { "deno.json" },
	workspace_required = true,
})
vim.lsp.config("ts_ls", {
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json" },
	workspace_required = true,
})
-- vim.lsp.config("htmx", {
-- 	filetypes = {
-- 		"html",
-- 	},
-- })

-- vim.lsp.enable("copilot")
vim.lsp.enable("pyright")
-- vim.lsp.enable("denols")
vim.lsp.enable("ts_ls")
vim.lsp.enable("prismals")
-- vim.lsp.enable("clangd")
vim.lsp.config("html", {
	filetypes = { "html", "hbs", "handlebars" },
})
vim.lsp.enable("html")
vim.lsp.enable("htmx")
vim.lsp.enable("css_variables")
vim.lsp.enable("expert") -- elixir
vim.lsp.config("tailwindcss", {
	filetypes = {
		"html",
		"css",
		"javascript",
		"typescript",
		"javascriptreact",
		"typescriptreact",
		"vue",
		"svelte",
		"hbs",
		"handlebars",
	},
})
vim.lsp.enable("tailwindcss")
-- vim.lsp.enable("astro")

vim.lsp.config("lua_ls", {
	on_init = function(client)
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			if
				path ~= vim.fn.stdpath("config")
				and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
			then
				return
			end
		end

		client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
			runtime = {
				-- Tell the language server which version of Lua you're using (most
				-- likely LuaJIT in the case of Neovim)
				version = "LuaJIT",
				-- Tell the language server how to find Lua modules same way as Neovim
				-- (see `:h lua-module-load`)
				path = {
					"lua/?.lua",
					"lua/?/init.lua",
				},
			},
			-- Make the server aware of Neovim runtime files
			workspace = {
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
					-- Depending on the usage, you might want to add additional paths
					-- here.
					-- '${3rd}/luv/library'
					-- '${3rd}/busted/library'
				},
				-- Or pull in all of 'runtimepath'.
				-- NOTE: this is a lot slower and will cause issues when working on
				-- your own configuration.
				-- See https://github.com/neovim/nvim-lspconfig/issues/3189
				-- library = {
				--   vim.api.nvim_get_runtime_file('', true),
				-- }
			},
		})
	end,
	settings = {
		Lua = {},
	},
})

vim.lsp.enable("lua_ls")

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, {
				buffer = event.buf,
				desc = "LSP: " .. desc,
			})
		end
		map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
		map("gh", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
		map("gi", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
		map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")
		map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
		-- map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
		map("K", vim.lsp.buf.hover, "Hover Documentation")
		map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	end,
})
