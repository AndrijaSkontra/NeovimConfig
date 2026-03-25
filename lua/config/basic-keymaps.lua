vim.keymap.set("i", "<C-E>", "<C-X><C-E><C-X><C-E>")
vim.keymap.set("i", "<C-Y>", "<C-X><C-Y><C-X><C-Y>")
vim.keymap.set("n", "<C-E>", "<C-E><C-E>")
vim.keymap.set("n", "<C-Y>", "<C-Y><C-Y>")

-- Move through wrapped lines with j/k
vim.keymap.set("n", "j", "gj", { noremap = true, silent = true })
vim.keymap.set("n", "k", "gk", { noremap = true, silent = true })
vim.keymap.set("v", "j", "gj", { noremap = true, silent = true })
vim.keymap.set("v", "k", "gk", { noremap = true, silent = true })

-- Navigate to beginning/end of wrapped lines
vim.keymap.set("n", "<S-A-h>", "g0", { noremap = true, silent = true })
vim.keymap.set("n", "<S-A-l>", "g$", { noremap = true, silent = true })
vim.keymap.set("v", "<S-A-h>", "g0", { noremap = true, silent = true })
vim.keymap.set("v", "<S-A-l>", "g$", { noremap = true, silent = true })

-- Navigation between panes/windows
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
-- Terminal mode keymaps
vim.keymap.set("t", "<C-h>", "<C-\\><C-n><C-w>h", { desc = "Move focus to the left window" })
vim.keymap.set("t", "<C-j>", "<C-\\><C-n><C-w>j", { desc = "Move focus to the lower window" })
vim.keymap.set("t", "<C-k>", "<C-\\><C-n><C-w>k", { desc = "Move focus to the upper window" })
vim.keymap.set("t", "<C-l>", "<C-\\><C-n><C-w>l", { desc = "Move focus to the right window" })

-- refactor this into a helper file...
local function is_macos()
	-- return os.getenv("HOME") and os.getenv("HOME"):match("^/Users/") ~= nil
	return false -- comment out in ghostty
end
-- this should check is this a macos device
if is_macos() then
	vim.api.nvim_set_keymap("n", "∆", "12jzz", {})
	vim.api.nvim_set_keymap("n", "˚", "12kzz", {})
	vim.api.nvim_set_keymap("v", "∆", "<C-d>zz", {})
	vim.api.nvim_set_keymap("v", "˚", "<C-u>zz", {})
	vim.api.nvim_set_keymap("n", "˙", "_", {})
	vim.api.nvim_set_keymap("n", "¬", "$", {})
	vim.api.nvim_set_keymap("v", "˙", "_", {})
	vim.api.nvim_set_keymap("v", "¬", "$", {})
else
	vim.api.nvim_set_keymap("n", "<A-j>", "12jzz", {})
	vim.api.nvim_set_keymap("n", "<A-k>", "12kzz", {})
	vim.api.nvim_set_keymap("v", "<A-j>", "<C-d>zz", {})
	vim.api.nvim_set_keymap("v", "<A-k>", "<C-u>zz", {})
	vim.api.nvim_set_keymap("n", "<A-h>", "_", {})
	vim.api.nvim_set_keymap("n", "<A-l>", "$", {})
	vim.api.nvim_set_keymap("v", "<A-h>", "_", {})
	vim.api.nvim_set_keymap("v", "<A-l>", "$", {})
end

-- Navigation between panes/windows

-- COPY PASTE
vim.api.nvim_set_keymap("v", "<C-c>", '"+y', {})
vim.api.nvim_set_keymap("n", "d", '"ad', { noremap = true })
vim.api.nvim_set_keymap("v", "d", '"ad', { noremap = true })
vim.api.nvim_set_keymap("n", "dd", '"add', { noremap = true })
vim.api.nvim_set_keymap("n", "x", '"bx', { noremap = true })
vim.api.nvim_set_keymap("n", "c", '"_c', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>p", '"ap', { noremap = true })
vim.api.nvim_set_keymap("v", "<leader>p", '"ap', { noremap = true })
-- COPY PASTE

-- Diagnostics
vim.keymap.set("n", "]]", '<cmd>lua vim.diagnostic.goto_next({ float =  { border = "single" } })<cr>')
vim.keymap.set("n", "[[", '<cmd>lua vim.diagnostic.goto_prev({ float =  { border = "single" }})<cr>')
vim.keymap.set("n", "gl", '<cmd>lua vim.diagnostic.open_float({ border = "single" })<cr>')
vim.api.nvim_set_keymap("n", "g.", '<cmd>lua vim.lsp.buf.code_action({ float = { border = "single" } })<CR>', {})
-- Diagnostics

-- clear highlight after pressing esc
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- center on % jump, this blocks the default tag pair match, but we can still use that is visual mode
vim.api.nvim_set_keymap("n", "%", "%zz", { noremap = true, silent = true })

-- comment jsx or tsx
vim.keymap.set("n", "<leader>cc", "_i{/*<Space><Esc>$a<Space>*/}<Esc>", { desc = "Comment JSX" })
vim.keymap.set("n", "<leader>dc", "_xxxx$xxxx", { desc = "Comment JSX" })

-- copy whole file
vim.api.nvim_set_keymap("n", "<leader>cf", "ggVGy", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>w", "<cmd>w<CR>", { noremap = true })

function Git_log_visual_selection()
	print("hello")
	local start_line = vim.fn.line("'<")
	local end_line = vim.fn.line("'>")
	local file_name = vim.fn.expand("%")
	local git_command = string.format(":term git log -L%d,%d:%s", start_line, end_line, file_name)
	vim.cmd(git_command)
end

vim.api.nvim_set_keymap("v", "<leader>l", ":lua Git_log_visual_selection()<CR>", { noremap = true, silent = true })

vim.api.nvim_set_keymap(
	"n",
	"<leader>rc", -- Leader key + rc (for remove comments)
	":%s/\\/\\/.*$//g<CR>", -- Execute the substitution command
	{ noremap = true, silent = true, desc = "Remove // comments" }
)

local command_pane_winid = nil
local command_pane_bufnr = nil

local function run_project_command(mode)
	-- save current file
	vim.cmd("w")

	local command_file = ".command"
	if vim.fn.filereadable(command_file) == 0 then
		print("No .command file found in current directory")
		return
	end

	local file = io.open(command_file, "r")
	if not file then
		print("Could not open .command file")
		return
	end

	local command = file:read("*line")
	file:close()

	command = command and command:match("^%s*(.-)%s*$") or ""
	if command == "" then
		print(".command file is empty")
		return
	end

	-- close previous pane if it still exists
	if command_pane_winid and vim.api.nvim_win_is_valid(command_pane_winid) then
		vim.api.nvim_win_close(command_pane_winid, false)
		command_pane_winid = nil
		command_pane_bufnr = nil
	end

	-- create split
	if mode == "vertical" then
		vim.cmd("vsplit")
		vim.cmd("wincmd l")
	elseif mode == "horizontal" then
		vim.cmd("split")
		vim.cmd("wincmd j")
	end

	command_pane_winid = vim.api.nvim_get_current_win()

	-- create scratch buffer
	local buf = vim.api.nvim_create_buf(false, true)
	command_pane_bufnr = buf

	vim.api.nvim_win_set_buf(command_pane_winid, buf)

	-- buffer options
	vim.bo[buf].buftype = "nofile"
	vim.bo[buf].bufhidden = "wipe"
	vim.bo[buf].swapfile = false
	vim.bo[buf].modifiable = true
	vim.bo[buf].filetype = "log"

	vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
		"$ " .. command,
		"",
	})

	local function append_data(_, data)
		if not data or (#data == 1 and data[1] == "") then
			return
		end

		if vim.api.nvim_buf_is_valid(buf) then
			vim.schedule(function()
				if vim.api.nvim_buf_is_valid(buf) then
					vim.api.nvim_buf_set_lines(buf, -1, -1, false, data)
				end
			end)
		end
	end

	vim.fn.jobstart(command, {
		stdout_buffered = false,
		stderr_buffered = false,
		on_stdout = append_data,
		on_stderr = append_data,
		on_exit = function(_, code)
			if vim.api.nvim_buf_is_valid(buf) then
				vim.schedule(function()
					if vim.api.nvim_buf_is_valid(buf) then
						vim.api.nvim_buf_set_lines(buf, -1, -1, false, {
							"",
							"[Process exited with code " .. code .. "]",
						})
						vim.bo[buf].modifiable = false
					end
				end)
			end
		end,
	})

	vim.api.nvim_create_autocmd("WinClosed", {
		pattern = tostring(command_pane_winid),
		callback = function()
			if command_pane_winid == tonumber(vim.fn.expand("<amatch>")) then
				command_pane_winid = nil
				command_pane_bufnr = nil
			end
		end,
		once = true,
	})
end

-- Create the keymap
vim.keymap.set("n", "<leader>!", function()
	run_project_command("vertical")
end, {
	desc = "Toggle command pane from .command file in vertical split",
	silent = true,
})

vim.keymap.set("n", "<leader>=", function()
	run_project_command("horizontal")
end, {
	desc = "Toggle command pane from .command file in horizontal split",
	silent = true,
})

vim.keymap.set("n", "<leader>tt", "<CMD>terminal<CR>")
-- vim.keymap.set("n", "<leader><leader>", function()
-- 	if vim.fn.winnr("$") > 1 then
-- 		vim.cmd("q")
-- 	end
-- end, {})

-- Inc number change because of tmux, not using tmux anymore
-- vim.keymap.set("n", "<C-a>", "<C-c>", { noremap = true, silent = true })
