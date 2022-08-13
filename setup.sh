#!/bin/bash

git submodule init
git submodule update --depth 1

# nerd font
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLo ""

# zsh
RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
ln -s "$(realpath .zshrc)" ~
ln -s "$(realpath .p10k.zsh)" ~

# nvim 
git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
mkdir -p ~/.config/nvim/lua/user/
ln -s "$(realpath init.lua)" ~/.config/nvim/lua/user/
nvim  --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

echo -e "\nREMINDER:::\npackages needed: zsh zsh-autosuggestions zsh-syntax-highlighting\n\tneovim powerline-fonts fontawesome-fonts git-credential-libsecret"
