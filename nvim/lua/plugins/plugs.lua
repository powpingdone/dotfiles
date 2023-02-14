return {
  -- edge
  { "sainnhe/edge" },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "edge",
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = { "BufNewFile", "BufEnter" },
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufNewFile", "BufEnter" },
  },
}
