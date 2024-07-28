local M = {}

M.namespace = vim.api.nvim_create_namespace("diagnostic_comments")

M.config = {
	comment_style = "above", -- 'above' or 'inline'
	keymap = "<leader>dc", -- default keymap to toggle diagnostic comments
	comment_prefix = "--", -- new option for comment prefix
}

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

function M.update_diagnostic_comments()
	print("Updating diagnostic comments")
	vim.api.nvim_buf_clear_namespace(0, M.namespace, 0, -1)
	local diagnostics = vim.diagnostic.get(0)
	print("Number of diagnostics: " .. #diagnostics)
	for _, diagnostic in ipairs(diagnostics) do
		local line = diagnostic.lnum
		local message = diagnostic.message
		local severity = diagnostic.severity
		local comment_text =
			string.format("%s %s: %s", M.config.comment_prefix, vim.diagnostic.severity[severity], message)
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
