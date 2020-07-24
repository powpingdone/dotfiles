if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=$HOME/.config/nvim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('$HOME/.config/nvim/dein')
  call dein#begin('$HOME/.config/nvim/dein')

  " Let dein manage dein
  " Required:
  call dein#add('$HOME/.config/nvim/dein/repos/github.com/Shougo/dein.vim')

  " ---- Plugins ----
  " Theming
  call dein#add('vim-airline/vim-airline') " Provides a cool looking bar across the bottom
  call dein#add('vim-airline/vim-airline-themes') " Provides themes for the cool looking bar 
  call dein#add('sainnhe/edge') " Provides color scheme
  
  " Programming Utils
  call dein#add('Chiel92/vim-autoformat') " Creates the :Autoformat for formatting
  call dein#add('neoclide/coc.nvim', {'rev': 'release'}) " Provides language server support.
  call dein#add('sheerun/vim-polyglot') " Proper syntax highlighting
  call dein#add('tpope/vim-commentary') " Easy commenting with gd
  call dein#add('liuchengxu/vista.vim') " Lang server symbols

  " Misc utils
  call dein#add('vim-ctrlspace/vim-ctrlspace') " Provides the ctrl+space ui for switching between files
  call dein#add('wsdjeg/dein-ui.vim') " Creates the :DeinUpdate command for quick updating
  call dein#add('junegunn/fzf') " fzf for finding files
  call dein#add('junegunn/fzf.vim') " fzf vim bindings/commands
  call dein#add('liuchengxu/vim-which-key') " See what keys do
  call dein#add('lambdalisue/suda.vim') " use sudo to open files I cant open normallf

  " Git Utils
  call dein#add('tpope/vim-fugitive') " git intergration, required for the rest of the git-related plugins
  call dein#add('airblade/vim-gitgutter') " shows the git diff in the side bar
  call dein#add('junegunn/gv.vim') " git log browser

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

