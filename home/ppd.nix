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
    ../options.nix
    ./emacs
  ];

  home.stateVersion = "24.11";
  # regular config
  home.username = "powpingdone";
  home.homeDirectory = "/home/powpingdone";
  home.keyboard.layout = "us";
  home.language.base = "en_US.utf8";

  systemd.user.startServices = true;

  # any extra packages I feel like I need
  home.packages = with pkgs;
    [
      alejandra
    ]
    ++ lib.optionals nixosConfig.ppd.devenv.enable [pkgs.devenv];
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
}
