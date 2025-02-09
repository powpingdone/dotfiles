{ pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/cd-dvd/installation-cd-graphical-gnome.nix") ];
  environment.systemPackages = [ pkgs.neovim ];
}
