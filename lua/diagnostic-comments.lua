-- Diagnostic Comments Plugin for Neovim

local M = {}

-- Create a unique namespace for our plugin
M.namespace = vim.api.nvim_create_namespace("diagnostic_comments")

-- Default configuration options
M.config = {
	comment_style = "inline", -- 'above' or 'inline'
	keymap = "<leader>dc", -- default keymap to add diagnostic comments
	comment_prefix = "//", -- prefix for comments
	use_virtual_text = true, -- toggle between virtual and actual comments
}

-- Setup function to initialize the plugin with user config
function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	vim.api.nvim_set_keymap(
		"n",
		M.config.keymap,
		':lua require("diagnostic-comments").add_diagnostic_comment()<CR>',
		{ noremap = true, silent = true }
	)
end

-- Function to update diagnostic comment for the current line
function M.update_diagnostic_comment()
	local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1

	-- Get diagnostics for the current line only
	local diagnostics = vim.diagnostic.get(0, { lnum = current_line })

	if #diagnostics > 0 then
		local diagnostic = diagnostics[1] -- Use the first diagnostic if there are multiple
		local message = diagnostic.message
		local severity = vim.diagnostic.severity[diagnostic.severity]
		local comment_text = string.format("%s %s: %s", M.config.comment_prefix, severity, message)

		if M.config.use_virtual_text then
			-- Add virtual text
			vim.api.nvim_buf_set_extmark(0, M.namespace, current_line, 0, {
				virt_text = { { comment_text, "Comment" } },
				virt_text_pos = "eol",
			})
		else
			-- Add actual comment
			M.add_actual_comment(current_line, comment_text)
		end
		-- print("Diagnostic comment added")
	else
		-- print("No diagnostics on current line")
	end
end

-- Function to add an actual comment to the buffer
function M.add_actual_comment(line, comment_text)
	local current_line_text = vim.api.nvim_buf_get_lines(0, line, line + 1, false)[1]
	local new_line
	if M.config.comment_style == "above" then
		new_line = comment_text
		vim.api.nvim_buf_set_lines(0, line, line, false, { new_line })
	else
		new_line = current_line_text .. " " .. comment_text
		vim.api.nvim_buf_set_lines(0, line, line + 1, false, { new_line })
	end
end

-- Function to check if the previous line contains "ERROR"
local function has_error_above(line)
	if line <= 1 then
		return false
	end
	local prev_line = vim.api.nvim_buf_get_lines(0, line - 1, line, false)[1]
	return prev_line:find("ERROR") ~= nil
end

-- Function to add diagnostic comment, only if no "ERROR" above
function M.add_diagnostic_comment()
	local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
	if not has_error_above(current_line) then
		M.update_diagnostic_comment()
	end
end

return M
