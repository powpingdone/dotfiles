#!/bin/sh

# initial setup
which which 2 &
>1 >/dev/null
if [[ "$?" -ne "0" ]]; then
	echo "install which for this script."
	exit 1
fi

if [[ ! -x "$(which git)" ]]; then
	echo "install git"
	exit 1
fi

set -e
git submodule update --depth 1 --init --remote --merge

# nerd font
if [[ -x "$(which fc-cache)" ]]; then
	echo -e "\ncompiling fonts..."
	mkdir -p ~/.local/share/fonts
	nerd-fonts/install.sh
	fc-cache -rf
fi

# zsh
echo -e "\ninstalling omzsh and p10k"
# note: the omz dir is cleared out here becasue of distrobox issues
rm -rf ~/.oh-my-zsh/
ZSH=~/.oh-my-zsh RUNZSH=no sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
ln -fs "$(realpath .zshrc)" ~
ln -fs "$(realpath .p10k.zsh)" ~

# nvim
mkdir -p ~/.config/
echo -e "\nsymlinking neovim"
ln -fs "$(realpath nvim)" ~/.config/

# vscode
if [[ -x "$(which flatpak)" ]]; then
	echo -e "installing special vscode stuff"
	flatpak install -y com.visualstudio.code
	mkdir -p ~/.var/app/com.visualstudio.code/config/Code/User
	ln -fs "$(realpath settings.json)" ~/.var/app/com.visualstudio.code/config/Code/User/
	cat vscode_exts.txt | xargs -n 1 flatpak run com.visualstudio.code --install-extension
fi

# toolbox vscode
mkdir -p ~/.local/bin
ln -fs "$(realpath toolbox-vscode/code.sh)" ~/.local/bin/code

echo -e "\n\n:::REMINDERS:::"
echo -e "packages needed:"
echo -e "\tzsh zsh-autosuggestions zsh-syntax-highlighting neovim"
echo -e "\tpowerline-fonts fontawesome-fonts git-credential-libsecret"
echo -e "\nmake sure you setup toolbox-vscode"
echo -e "\nvscode also needs access to wayland"
