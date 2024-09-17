{ home-manager, inputs, pkgs, lib, config, ... }:
{
  imports = [
    ../modules
  ];

  home.username = "powpingdone";
  home.homeDirectory = "/home/powpingdone";
  home.keyboard.layout = "us";
  home.language.base = "en_US.utf8";

  # any extra packages I feel like I need
  home.packages = with pkgs; [];
  # shell related things
  home.shellAliases = {
    "grep" = "rg";
  };
  # programs by default in a cli
  programs.home-manager.enable = true;
  programs.git-credential-oauth.enable = true;
  programs.git = {
    enable = true;
    userName = "Aidan";
    userEmail = "aidanzcase@gmail.com";
  };
  programs.ripgrep.enable = true;
  programs.neovim.enable = true;

  # desktop
  programs.firefox.enable = config.modules.ppdesktop.enable;
  #config.modules.emacs.enable = desktop;

  # enable dark mode for gtk4
  dconf = {
    enable = config.modules.ppdesktop.enable;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };
}
