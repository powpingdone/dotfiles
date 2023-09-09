vim.g.mapleader = " "

local whichkey = require('which-key')

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fw', builtin.diagnostics, {})
whichkey.register({
	f = {
		name = "Find",
		g = "Grep",
		f = "Files",
		b = "Buffers",
		h = "Vim Help",
		w = "Diagnostics"
	},
}, {prefix = "<leader>"})

-- gitsigns
require('gitsigns').setup({
	on_attach = function(bufnr)
		local opts = { buffer = bufnr, remap = false }
		local gs = package.loaded.gitsigns

		vim.keymap.set('n', '<leader>gs', gs.stage_hunk, opts)
		vim.keymap.set('n', '<leader>gr', gs.reset_hunk, opts)
		vim.keymap.set('v', '<leader>gs', function() gs.stage_hunk { vim.fn.line('.'), vim.fn.line('v') } end, opts)
		vim.keymap.set('v', '<leader>gr', function() gs.reset_hunk { vim.fn.line('.'), vim.fn.line('v') } end, opts)
		vim.keymap.set('n', '<leader>gS', gs.stage_buffer, opts)
		vim.keymap.set('n', '<leader>gu', gs.undo_stage_hunk, opts)
		vim.keymap.set('n', '<leader>gR', gs.reset_buffer, opts)
		vim.keymap.set('n', '<leader>gp', gs.preview_hunk, opts)
		vim.keymap.set('n', '<leader>gb', gs.toggle_current_line_blame, opts)
		vim.keymap.set('n', '<leader>gB', function() gs.blame_line { full = true } end, opts)
		vim.keymap.set('n', '<leader>gd', gs.diffthis, opts)
		vim.keymap.set('n', '<leader>gD', function() gs.diffthis('~') end, opts)
		vim.keymap.set('n', '<leader>gl', gs.toggle_deleted, opts)

		whichkey.register({
			g = {
				name = "Git",
				s = "Stage Chunk",
				r = "Reset Chunk",
				S = "Stage Buffer",
				u = "Undo Stage Chunk",
				R = "Reset Buffer",
				p = "Preview Chunk",
				b = "Toggle Inline Blame",
				B = "Blame",
				d = "Diff Buffer",
				D = "Diff Everything",
				l = "Toggle Show Deleted",
			}
		}, { prefix = "<leader>" })
	end
})
