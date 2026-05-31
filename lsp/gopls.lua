return {
	cmd = { "gopls" },
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.work", "go.mod" },
	settings = {
		gopls = {
			directoryFilters = {
				"-node_modules",
				"-vendor",
				"-.git",
			},
		},
	},
}
