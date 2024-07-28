-- Diagnostic Comments Plugin for Neovim
-- This plugin allows for toggling diagnostic comments on the current line, either as virtual text or actual comments.

local M = {}

-- Create a unique namespace for our plugin
M.namespace = vim.api.nvim_create_namespace("diagnostic_comments")

-- Default configuration options
M.config = {
	comment_style = "inline", -- 'above' or 'inline'
	keymap = "<leader>dc", -- default keymap to toggle diagnostic comments
	comment_prefix = "//", -- prefix for comments
	use_virtual_text = true, -- toggle between virtual and actual comments
}

-- Setup function to initialize the plugin with user config
function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})

	vim.api.nvim_set_keymap(
		"n",
		M.config.keymap,
		':lua require("diagnostic-comments").toggle_diagnostic_comments()<CR>',
		{ noremap = true, silent = true }
	)
	print("Diagnostic comments plugin setup complete")
end

-- Function to update diagnostic comment for the current line
function M.update_diagnostic_comment()
	local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1

	-- Clear existing comment
	if M.config.use_virtual_text then
		vim.api.nvim_buf_clear_namespace(0, M.namespace, current_line, current_line + 1)
	else
		M.remove_actual_comment(current_line)
	end

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
		print("Diagnostic comment added")
	else
		print("No diagnostics on current line")
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

-- Function to remove the actual diagnostic comment from the current line
function M.remove_actual_comment(line)
	local current_line_text = vim.api.nvim_buf_get_lines(0, line, line + 1, false)[1]
	if M.config.comment_style == "above" then
		if current_line_text:match("^" .. vim.pesc(M.config.comment_prefix) .. " %u+: ") then
			vim.api.nvim_buf_set_lines(0, line, line + 1, false, {})
		end
	else
		local new_line = current_line_text:gsub("%s*" .. vim.pesc(M.config.comment_prefix) .. " %u+: .*$", "")
		vim.api.nvim_buf_set_lines(0, line, line + 1, false, { new_line })
	end
end

-- Track whether comment is currently visible on the current line
M.comment_visible = false

-- Function to toggle diagnostic comment on and off for the current line
function M.toggle_diagnostic_comments()
	local status, result = pcall(function()
		local current_line = vim.api.nvim_win_get_cursor(0)[1] - 1
		if M.comment_visible then
			-- Hide comment
			if M.config.use_virtual_text then
				vim.api.nvim_buf_clear_namespace(0, M.namespace, current_line, current_line + 1)
			else
				M.remove_actual_comment(current_line)
			end
			M.comment_visible = false
			print("Diagnostic comment hidden")
		else
			-- Show comment
			M.update_diagnostic_comment()
			M.comment_visible = true
		end
	end)
	if not status then
		print("Error in toggle_diagnostic_comments: " .. tostring(result))
	end
end

return M
