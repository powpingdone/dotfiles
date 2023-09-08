-- lsp
local lsp = require("lsp-zero")
lsp.preset("recommended")
lsp.nvim_workspace()
lsp.ensure_installed({})

lsp.on_attach(function(_, bufnr)
	local opts = { buffer = bufnr, remap = false }

	vim.keymap.set("n", "<leader>ld", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<leader>ls", vim.lsp.buf.workspace_symbol, opts)
	vim.keymap.set("n", "<leader>lD", vim.diagnostic.open_float, opts)
	vim.keymap.set("n", "<leader>ln", vim.diagnostic.goto_next, opts)
	vim.keymap.set("n", "<leader>lp", vim.diagnostic.goto_prev, opts)
	vim.keymap.set("n", "<leader>la", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>lR", vim.lsp.buf.references, opts)
	vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<leader>lF", vim.lsp.buf.format, opts)
	vim.keymap.set('n', '<leader>lt', require('treesj').toggle)

	require('which-key').register({
		 l = {
			name = "LSP",
			d = "Definition",
			s = "Symbol",
			D = "Diagnostic Floating",
			n = "Next Diagnostic",
			p = "Previous Diagnostic",
			a = "Code Action",
			R = "References",
			r = "Rename",
			F = "Format File",
			t = "Expand/Inline Code"
		}
	}, {prefix = "<leader>"} )
end)

lsp.setup()

vim.diagnostic.config({
	virtual_text = true
})
