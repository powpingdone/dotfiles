source $HOME/.config/nvim/deinpkg.vim
source $HOME/.config/nvim/cocfig.vim
source $HOME/.config/nvim/whichkey.vim
source $HOME/.config/nvim/plugconfig.vim

" Personal config
set number " line numbers
set hidden " buffers do not need to be saved
set nowrap " do not wrap characters 
set nolinebreak " do not insert newline on a line wrap
set mouse=a " use mouse 
set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab " tab settings
" unbind up, down, left, and right to not do anything
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
noremap <C-Up> <Nop>
noremap <C-Down> <Nop>
noremap <C-Left> <Nop>
noremap <C-Right> <Nop>
