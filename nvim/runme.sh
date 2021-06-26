#!/bin/sh

mkdir -p ~/.config/nvim/dein
sh ./deininstall.sh ~/.config/nvim/dein
cp *.vim *.json ~/.config/nvim/
nvim -c ":CocInstall coc-clangd coc-rls coc-python|q"
