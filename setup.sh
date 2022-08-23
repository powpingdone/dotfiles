#!/bin/bash

git submodule init
git submodule update --depth 1

# nerd font
mkdir -p ~/.local/share/fonts
nerd-fonts/install.sh
fc-cache -rf

# zsh
RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
ln -s "$(realpath .zshrc)" ~
ln -s "$(realpath .p10k.zsh)" ~

# nvim 
git clone https://github.com/AstroNvim/AstroNvim ~/.config/nvim
mkdir -p ~/.config/nvim/lua/user/
ln -s "$(realpath init.lua)" ~/.config/nvim/lua/user/
nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'

# vscodium 
flatpak install -y com.vscodium.codium
mkdir -p ~/.var/app/com.vscodium.codium/config/Code/User
ln -s "$(realpath settings.json)" ~/.var/app/com.vscodium.codium/config/Code/User/
cat vscode_exts.txt | xargs -n 1 flatpak run com.vscodium.codium --install-extension

echo -e "\n\n:::REMINDER:::"
echo -e "packages needed:"
echo -e "\tzsh zsh-autosuggestions zsh-syntax-highlighting neovim"
echo -e "\tpowerline-fonts fontawesome-fonts git-credential-libsecret"
