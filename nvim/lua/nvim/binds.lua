vim.g.mapleader = " "

-- telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fw', builtin.diagnostics, {})

-- whichkey
require('which-key').register({
	f = {
		name = "Find",
		g = "Grep",
		f = "Files",
		b = "Buffers",
		h = "Vim Help",
		w = "Diagnostics"
	},
}, {prefix = "<leader>"})
