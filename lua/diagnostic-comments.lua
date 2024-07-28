local M = {}

-- Move namespace creation to the top
M.namespace = vim.api.nvim_create_namespace("diagnostic_comments")

M.config = {
	comment_style = "above", -- 'above' or 'inline'
	keymap = "<leader>dc", -- default keymap to toggle diagnostic comments
}

function M.setup(opts)
	M.config = vim.tbl_deep_extend("force", M.config, opts or {})
	-- Set up the keymap
	vim.api.nvim_set_keymap(
		"n",
		M.config.keymap,
		':lua require("diagnostic_comments").toggle_diagnostic_comments()<CR>',
		{ noremap = true, silent = true }
	)
	print("Diagnostic comments plugin setup complete")
end

function M.update_diagnostic_comments()
	print("Updating diagnostic comments")
	-- Clear existing diagnostic comments
	vim.api.nvim_buf_clear_namespace(0, M.namespace, 0, -1)
	-- Get diagnostics for the current buffer
	local diagnostics = vim.diagnostic.get(0)
	print("Number of diagnostics: " .. #diagnostics)
	for _, diagnostic in ipairs(diagnostics) do
		local line = diagnostic.lnum
		local message = diagnostic.message
		local severity = diagnostic.severity
		-- Create the comment text
		local comment_text = string.format("-- %s: %s", vim.diagnostic.severity[severity], message)
		if M.config.comment_style == "above" then
			-- Add the comment on a new line above
			vim.api.nvim_buf_set_extmark(0, M.namespace, line, 0, {
				virt_lines = { { { "-- " .. vim.diagnostic.severity[severity] .. ": " .. message, "Comment" } } },
				virt_lines_above = true,
			})
		else
			-- Add the comment to the end of the line as virtual text
			vim.api.nvim_buf_set_extmark(0, M.namespace, line, 0, {
				virt_text = { { comment_text, "Comment" } },
				virt_text_pos = "eol",
			})
		end
	end
	print("Diagnostic comments update complete")
end

M.comments_visible = false

function M.toggle_diagnostic_comments()
	local status, result = pcall(function()
		if M.comments_visible then
			vim.api.nvim_buf_clear_namespace(0, M.namespace, 0, -1)
			M.comments_visible = false
			print("Diagnostic comments hidden")
		else
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
