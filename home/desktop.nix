{ lib, config, ... }:
{
  config = lib.mkIf config.ppd.desktop.enable { 
    programs.firefox.enable = true;
    #ppd.emacs.enable = true;
  
    # enable dark mode for gtk4
    dconf = {
      enable = true;
      settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
    };
  };
}
