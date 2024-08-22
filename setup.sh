#!/bin/bash

# initial setup
which which
if [[ "$?" -ne "0" ]]; then
	echo "install which for this script."
	exit 1
fi

if [[ ! -x "$(which git)" ]]; then
	echo "install git"
	exit 1
fi

mkdir -p ~/.config

# update internal modules
git submodule update --depth 1 --init --remote --merge
set -e

# zsh
echo -e "\ninstalling omzsh and p10k"
# note: the omz dir is cleared out here becasue of distrobox issues
rm -rf ~/.oh-my-zsh/
ZSH=~/.oh-my-zsh RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
ln -fs "$(realpath .zshrc)" ~
ln -fs "$(realpath .p10k.zsh)" ~


# nvim
echo -e "\nsymlinking neovim"
ln -fs "$(realpath nvim)" ~/.config/

# emacs
ln -fs "$(realpath doomemacs)" ~/.config/emacs
ln -fs "$(realpath doomcfg)" ~/.config/doom
~/.config/emacs/bin/doom install

echo -e "\n\n:::REMINDERS:::"
echo -e "packages needed:"
echo -e "\tzsh zsh-autosuggestions zsh-syntax-highlighting neovim"
echo -e "\tgit-credential-oauth"
