local M = {}

local command_pane_winid = nil
local command_pane_bufnr = nil

function M.run(mode)
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

	if command_pane_winid and vim.api.nvim_win_is_valid(command_pane_winid) then
		vim.api.nvim_win_close(command_pane_winid, false)
		command_pane_winid = nil
		command_pane_bufnr = nil
	end

	if mode == "vertical" then
		vim.cmd("vsplit")
		vim.cmd("wincmd l")
	elseif mode == "horizontal" then
		vim.cmd("split")
		vim.cmd("wincmd j")
	end

	command_pane_winid = vim.api.nvim_get_current_win()

	local buf = vim.api.nvim_create_buf(false, true)
	command_pane_bufnr = buf

	vim.api.nvim_win_set_buf(command_pane_winid, buf)

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

return M
