{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf config.ppd.fonts.enable {
  fonts = {
    packages = with pkgs; [
      # noto for reasonable, non bitmap coverage
      noto-fonts
      noto-fonts-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif

      # other, regular fonts
      winePackages.fonts
      roboto
      ubuntu_font_family
      dejavu_fonts
      freefont_ttf
      gyre-fonts
      liberation_ttf
      noto-fonts-color-emoji

      # nerd fonts, because I am gamer
      nerd-fonts.symbols-only
    ];
    fontconfig =
      {
        enable = true;
        allowBitmaps = false;
      }
      //
      # fontconfig DPI settings
      lib.mkIf config.ppd.isHIDPI {
        antialias = false;
        hinting.enable = false;
        subpixel.lcdfilter = "none";
      }
      // lib.mkIf (!config.ppd.isHIDPI) {
        # I know this is redundant, but it's fine
        antialias = true;
        hinting.enable = true;
        subpixel.lcdfilter = "default";
      };
  };
}
