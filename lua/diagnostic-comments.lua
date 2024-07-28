-- Create a table to hold the diagnostic comments plugin
local M = {}

-- Create a namespace for the diagnostic comments
M.namespace = vim.api.nvim_create_namespace("diagnostic_comments")

-- Define the default configuration for the plugin
M.config = {
	-- Style of comment: 'above' or 'inline'
	comment_style = "above",
	-- Keymap to toggle diagnostic comments
	keymap = "<leader>dc",
	-- Prefix for comments (new option)
	comment_prefix = "--",
}

-- Function to set up the plugin with optional configuration
function M.setup(opts)
	-- Merge the default configuration with the user-provided options
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
	-- Set up the keymap to toggle diagnostic comments
	vim.api.nvim_set_keymap(
		"n",
		M.config.keymap,
		':lua require("diagnostic-comments").toggle_diagnostic_comments()<CR>',
		{ noremap = true, silent = true }
	)
	print("Diagnostic comments plugin setup complete")
end

-- Function to update the diagnostic comments
function M.update_diagnostic_comments()
	print("Updating diagnostic comments")
	-- Clear the namespace to remove old comments
	vim.api.nvim_buf_clear_namespace(0, M.namespace, 0, -1)
	-- Get the diagnostics for the current buffer
	local diagnostics = vim.diagnostic.get(0)
	print("Number of diagnostics: " .. #diagnostics)
	-- Loop through each diagnostic and create a comment
	for _, diagnostic in ipairs(diagnostics) do
		local line = diagnostic.lnum
		local message = diagnostic.message
		local severity = diagnostic.severity
		-- Create the comment text with the prefix, severity, and message
		local comment_text =
			string.format("%s %s: %s", M.config.comment_prefix, vim.diagnostic.severity[severity], message)
		-- Depending on the comment style, create a virtual line above or inline comment
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
	end
	print("Diagnostic comments update complete")
end

-- Flag to track whether the comments are currently visible
M.comments_visible = false

-- Function to toggle the diagnostic comments
function M.toggle_diagnostic_comments()
	local status, result = pcall(function()
		-- If the comments are currently visible, hide them
		if M.comments_visible then
			vim.api.nvim_buf_clear_namespace(0, M.namespace, 0, -1)
			M.comments_visible = false
			print("Diagnostic comments hidden")
		-- If the comments are not visible, show them
		else
			M.update_diagnostic_comments()
			M.comments_visible = true
			print("Diagnostic comments shown")
		end
	end)
	-- If there was an error, print it
	if not status then
		print("Error in toggle_diagnostic_comments: " .. tostring(result))
	end
end

-- Return the plugin table
return M
