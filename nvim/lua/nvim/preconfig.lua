-- vimcfg
vim.opt.fsync = true
vim.opt.number = true
vim.opt.numberwidth = 4
vim.opt.showbreak = ">> "
vim.opt.incsearch = true
vim.opt.signcolumn = "yes:2"
vim.opt.scrolloff = 8

-- edge
if vim.fn.has("termguicolors") then
	vim.opt.termguicolors = true
end

vim.g.edge_better_performance = 1

-- rainbow delimeters
vim.g.rainbow_delimiters = {
	highlight = {
		'RainbowDelimeterYellow',
		'RainbowDelimeterCyan',
		'RainbowDelimeterViolet',
	}
}

vim.cmd([[
	augroup EdgeCustom
		autocmd!
		autocmd ColorScheme edge highlight! link RainbowDelimeterYellow Yellow
		autocmd ColorScheme edge highlight! link RainbowDelimeterCyan Cyan
		autocmd ColorScheme edge highlight! link RainbowDelimeterViolet Purple
	augroup END	
]])
