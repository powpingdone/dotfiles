{ inputs, nixpkgs, config, lib, ... }:
{
  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users.powpingdone = {
      home.username = "powpingdone";
      home.homeDirectory = "/ppd";
      home.keyboard.layout = "us";
      home.language.base = "en_US.utf8";

      # any extra packages I feel like I need
      home.packages = with nixpkgs; [];

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
      config = lib.mkIf (config.modules.ppdesktop.enable) {
        programs.firefox.enable = true;
        config.modules.emacs.enable = lib.mkForce true;

        # enable dark mode for gtk4
        dconf = {
          enable = true;
          settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
        };
      };

      # home state
      stateVersion = "24.11";
    };
  };
}
