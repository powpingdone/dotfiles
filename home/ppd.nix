{
  home-manager,
  inputs,
  pkgs,
  lib,
  hostName,
  nixosConfig,
  ...
}: {
  imports = [
    ./desktop.nix
    ../options
    ./emacs
    ./devel.nix
  ];

  home.stateVersion = "25.05";
  # regular config
  home.username = "powpingdone";
  home.homeDirectory = "/home/powpingdone";
  home.keyboard.layout = "us";
  home.language.base = "en_US.utf8";

  systemd.user.startServices = true;

  # any extra packages I feel like I need
  home.packages = with pkgs; [
    alejandra
  ];
  # shell related things
  home.shellAliases = {
    "grep" = "rg";
    "rescan-yubikey" = ''gpg-connect-agent "scd serialno" "learn --force" /bye'';
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
  programs.zsh.enable = true;
}
