-- Diagnostic Comments Plugin for Neovim
-- This plugin allows for toggling diagnostic comments, either as virtual text or actual comments in the buffer.

local M = {}

-- Create a unique namespace for our plugin
M.namespace = vim.api.nvim_create_namespace("diagnostic_comments")

-- Default configuration options
M.config = {
	comment_style = "above", -- 'above' or 'inline'
	keymap = "<leader>dc", -- default keymap to toggle diagnostic comments
	comment_prefix = "--", -- prefix for comments
	use_virtual_text = true, -- toggle between virtual and actual comments
}

-- Setup function to initialize the plugin with user config
function M.setup(opts)
	-- Merge user config with default config
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
	-- Set up the keymap for toggling diagnostic comments
	vim.api.nvim_set_keymap(
		"n",
		M.config.keymap,
		':lua require("diagnostic-comments").toggle_diagnostic_comments()<CR>',
		{ noremap = true, silent = true }
	)
	print("Diagnostic comments plugin setup complete")
end

-- Function to update diagnostic comments
function M.update_diagnostic_comments()
	print("Updating diagnostic comments")
	-- Clear existing comments
	if M.config.use_virtual_text then
		vim.api.nvim_buf_clear_namespace(0, M.namespace, 0, -1)
	else
		M.remove_actual_comments()
	end
	-- Get diagnostics for the current buffer
	local diagnostics = vim.diagnostic.get(0)
	print("Number of diagnostics: " .. #diagnostics)
	-- Add comments for each diagnostic
	for _, diagnostic in ipairs(diagnostics) do
		local line = diagnostic.lnum
		local message = diagnostic.message
		local severity = vim.diagnostic.severity[diagnostic.severity]
		local comment_text = string.format("%s %s: %s", M.config.comment_prefix, severity, message)
		if M.config.use_virtual_text then
			-- Add virtual text
			if M.config.comment_style == "above" then
				vim.api.nvim_buf_set_extmark(0, M.namespace, line, 0, {
					virt_lines = { { { comment_text, "Comment" } } },
					virt_lines_above = true,
				})
			else
				vim.api.nvim_buf_set_extmark(0, M.namespace, line, 0, {
					virt_text = { { comment_text, "Comment" } },
					virt_text_pos = "eol",
				})
			end
		else
			-- Add actual comment
			M.add_actual_comment(line, comment_text)
		end
	end
	print("Diagnostic comments update complete")
end

-- Function to add an actual comment to the buffer
function M.add_actual_comment(line, comment_text)
	local current_line = vim.api.nvim_buf_get_lines(0, line, line + 1, false)[1]
	if M.config.comment_style == "above" then
		vim.api.nvim_buf_set_lines(0, line, line, false, { comment_text, current_line })
	else
		local new_line = current_line .. " " .. comment_text
		vim.api.nvim_buf_set_lines(0, line, line + 1, false, { new_line })
	end
end

-- Function to remove all actual diagnostic comments from the buffer
function M.remove_actual_comments()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local new_lines = {}
	local i = 1
	while i <= #lines do
		if not lines[i]:match("^" .. vim.pesc(M.config.comment_prefix) .. " %u+: ") then
			if M.config.comment_style == "inline" then
				lines[i] = lines[i]:gsub("%s*" .. vim.pesc(M.config.comment_prefix) .. " %u+: .*$", "")
			end
			table.insert(new_lines, lines[i])
		end
		i = i + 1
	end
	vim.api.nvim_buf_set_lines(0, 0, -1, false, new_lines)
end

-- Track whether comments are currently visible
M.comments_visible = false

-- Function to toggle diagnostic comments on and off
function M.toggle_diagnostic_comments()
	local status, result = pcall(function()
		if M.comments_visible then
			-- Hide comments
			if M.config.use_virtual_text then
				vim.api.nvim_buf_clear_namespace(0, M.namespace, 0, -1)
			else
				M.remove_actual_comments()
			end
			M.comments_visible = false
			print("Diagnostic comments hidden")
		else
			-- Show comments
			M.update_diagnostic_comments()
			M.comments_visible = true
			print("Diagnostic comments shown")
		end
	end)
	if not status then
		print("Error in toggle_diagnostic_comments: " .. tostring(result))
	end
end

return M
