require("lazy").setup({
	"folke/lazy.nvim",
	{
		"sainnhe/edge",
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[
				colorscheme edge
			]])
		end
	},
	{
		'nvim-telescope/telescope.nvim',
		branch = '0.1.x',
		dependencies = { 'nvim-lua/plenary.nvim' },
		config = function()
			local tsc = require("telescope")
			tsc.load_extension("flutter")
			tsc.setup({})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { "lua", "vim", "vimdoc", "query" },
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true, disable = { 'dart' } },
			})
		end
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = function()
			require("treesitter-context").setup({
				mode = 'topline',
			})
		end,
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
	},
	{
		'folke/trouble.nvim',
		opts = {
			icons = false
		}
	},
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v1.x',
		dependencies = {
			-- LSP Support
			'neovim/nvim-lspconfig',
			'williamboman/mason.nvim',
			'williamboman/mason-lspconfig.nvim',

			-- Autocompletion
			'hrsh7th/nvim-cmp',
			'hrsh7th/cmp-buffer',
			'hrsh7th/cmp-path',
			'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-nvim-lua',

			-- Snippets
			'L3MON4D3/LuaSnip',
			'rafamadriz/friendly-snippets',
			'nvim-tree/nvim-web-devicons'
		}
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
	},
	{
		'Wansmer/treesj',
		dependencies = { 'nvim-treesitter/nvim-treesitter' },
		config = function()
			require('treesj').setup({
				max_join_length = 9999999,
				use_default_keymaps = false,
			})
		end,
	},
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			require('lualine').setup({})
		end
	},
	{
		"folke/noice.nvim",
		event = "VeryLazy",
		dependencies = {
			"MunifTanjim/nui.nvim",
			"rcarriga/nvim-notify",
		},
		config = function()
			require('noice').setup()
		end
	},
	{
		"lewis6991/gitsigns.nvim",
		dependencies = {
			'nvim-tree/nvim-web-devicons',
			'folke/trouble.nvim',
		},
	},
	{
		"akinsho/flutter-tools.nvim",
		lazy = false,
		dependencies = {
			'nvim-lua/plenary.nvim',
		},
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			window = {
				backdrop = 0.92,
			},
			plugins = {
				twilight = false,
			},
		}
	},
	{
		"folke/neodev.nvim"
	},
	{
		'saecki/crates.nvim',
		event = { "BufRead Cargo.toml" },
		dependencies = {
			'VonHeikemen/lsp-zero.nvim',
			'nvim-lua/plenary.nvim'
		},
		config = function()
			require('crates').setup()
		end,
	},
	{
		"tpope/vim-sleuth",
		event = "BufRead",
	},
})
