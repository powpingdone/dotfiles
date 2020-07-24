#!/bin/sh

mkdir -p ~/.config/nvim/dein
sh ./deininstall.sh ~/.config/nvim/dein
mv *.vim ~/.config/nvim/
nvim -c ":CocInstall coc-clangd coc-rls coc-python|q"
