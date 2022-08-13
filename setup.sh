#!/bin/bash

# zsh
RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
ln -s "$(realpath .zshrc)" ~
ln -s "$(realpath .p10k.zsh)" ~

# nvim 
git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
nvim +PackerSync
