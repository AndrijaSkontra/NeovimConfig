vim.lsp.config("denols", {
	root_markers = { "deno.json" },
	workspace_required = true,
})
vim.lsp.config("ts_ls", {
	root_markers = { "tsconfig.json", "jsconfig.json", "package.json" },
	workspace_required = true,
	filetypes = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
	},
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
	filetypes = { "html", "hbs", "handlebars", "heex" },
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
		"heex",
		"elixir",
		"html-eex",
	},
})
vim.lsp.enable("tailwindcss") -- for this to work tailwind.config.js needs to be in the project root
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

vim.lsp.config("gopls", {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.work", "go.mod", ".git" },
})
vim.lsp.enable("gopls")

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

vim.lsp.enable("phptools")

-- Snippet to enable the language server: >lua
vim.lsp.config("ruby_lsp", {
	filetypes = { "ruby" },
	cmd = { "ruby-lsp" },
	root_markers = { "Gemfile", ".git" },
	init_options = {
		addonSettings = {
			["Ruby LSP Rails"] = {
				enablePendingMigrationsPrompt = false,
			},
		},
	},
})
vim.lsp.enable("ruby_lsp")
-- vim.lsp.enable("ruby_lsp")

-- Default config:
-- - cmd (use "gF" to view): ../lsp/ruby_lsp.lua:16
-- - filetypes: >lua
--   { "ruby", "eruby" }
-- - init_options: >lua
--   {
--     formatter = "auto"
--   }
-- - reuse_client (use "gF" to view): ../lsp/ruby_lsp.lua:16
-- - root_markers: >lua
--   { "Gemfile", ".git" }
--
